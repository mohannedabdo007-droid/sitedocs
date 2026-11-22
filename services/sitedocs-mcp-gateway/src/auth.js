export function isAuthorized(request, expectedToken) {
  if (typeof expectedToken !== "string" || expectedToken.length < 32) {
    return false;
  }

  const authorization = request.headers.get("authorization") ?? "";
  const prefix = "Bearer ";
  if (!authorization.startsWith(prefix)) return false;

  const supplied = authorization.slice(prefix.length);
  if (supplied.length !== expectedToken.length) return false;

  // Compare every character instead of returning on the first mismatch.
  let mismatch = 0;
  for (let i = 0; i < expectedToken.length; i += 1) {
    mismatch |= supplied.charCodeAt(i) ^ expectedToken.charCodeAt(i);
  }
  return mismatch === 0;
}
