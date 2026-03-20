exports.handler = async (event) => {
  if (event.httpMethod !== "POST") {
    return {
      statusCode: 405,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: "Method not allowed." }),
    };
  }

  const apiKey = process.env.BUTTONDOWN_API_KEY;
  if (!apiKey) {
    return {
      statusCode: 500,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: "Newsletter signup is not configured yet." }),
    };
  }

  const params = new URLSearchParams(event.body || "");
  const email = (params.get("email") || "").trim();
  const honeypot = (params.get("company") || "").trim();
  const tag = (params.get("tag") || "").trim();

  if (honeypot) {
    return {
      statusCode: 200,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: "Check your inbox to confirm your subscription." }),
    };
  }

  if (!email) {
    return {
      statusCode: 400,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: "Please enter an email address." }),
    };
  }

  const forwardedFor = event.headers["x-forwarded-for"] || event.headers["X-Forwarded-For"] || "";
  const ipAddress = forwardedFor.split(",")[0].trim();

  const payload = {
    email_address: email,
    notes: "Subscribed from taletskiy.com newsletter form",
  };

  if (ipAddress) {
    payload.ip_address = ipAddress;
  }

  if (tag) {
    payload.tags = [tag];
  }

  try {
    const response = await fetch("https://api.buttondown.com/v1/subscribers", {
      method: "POST",
      headers: {
        Authorization: `Token ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    const data = await response.json().catch(() => ({}));

    if (response.ok) {
      return {
        statusCode: 200,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          message: "Success! Check your inbox to confirm your subscription.",
        }),
      };
    }

    const message =
      data.detail ||
      data.email_address?.[0] ||
      data.email ||
      "Subscription failed. Please try again.";

    return {
      statusCode: response.status === 400 ? 400 : 502,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message }),
    };
  } catch {
    return {
      statusCode: 502,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        message: "Unable to reach Buttondown right now. Please try again.",
      }),
    };
  }
};
