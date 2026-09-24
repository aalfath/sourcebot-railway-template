// Signs in once with SOURCEBOT_ADMIN_EMAIL / SOURCEBOT_ADMIN_PASSWORD. On a fresh database the
// credentials provider creates that user, and the first user becomes the organization owner.
const base = `http://127.0.0.1:${process.env.PORT || 3000}`;
const email = process.env.SOURCEBOT_ADMIN_EMAIL;
const password = process.env.SOURCEBOT_ADMIN_PASSWORD;
if (!email || !password) {
  console.log("sourcebot: SOURCEBOT_ADMIN_EMAIL/PASSWORD not set, skipping admin bootstrap");
  process.exit(0);
}
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
for (let i = 0; ; i++) {
  try {
    if ((await fetch(`${base}/api/health`)).ok) break;
  } catch {}
  if (i > 200) throw new Error("web app did not become healthy");
  await sleep(3000);
}
const csrf = await fetch(`${base}/api/auth/csrf`);
const { csrfToken } = await csrf.json();
const cookie = csrf.headers.getSetCookie().map((c) => c.split(";")[0]).join("; ");
const res = await fetch(`${base}/api/auth/callback/credentials`, {
  method: "POST",
  redirect: "manual",
  headers: { "content-type": "application/x-www-form-urlencoded", cookie },
  body: new URLSearchParams({ email, password, csrfToken }),
});
const location = res.headers.get("location") || "";
if (location.includes("error")) throw new Error(`sign-in rejected (${location})`);
console.log(`sourcebot: admin ${email} signed in (first account on a fresh database becomes the owner)`);
