import React, { useState } from "react";
import axios from "axios";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [msg, setMsg] = useState("");
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMsg("");
    try {
      const res = await axios.post("/api/login", { email, password });
      localStorage.setItem("access_token", res.data.access_token);
      setMsg("Login successful!");
      window.location.href = "/profile";
    } catch (err) {
      setMsg("Login failed: " + (err.response?.data?.detail || err.message));
    }
    setLoading(false);
  };

  const handleSocial = (provider) => {
    window.location.href = `/api/login/social/${provider}`;
  };

  return (
    <div className="login medieval-card">
      <h2>Login</h2>
      <form onSubmit={handleLogin}>
        <label>Email</label>
        <input value={email} onChange={e => setEmail(e.target.value)} required />
        <label>Password</label>
        <input type="password" value={password} onChange={e => setPassword(e.target.value)} required />
        <button type="submit" disabled={loading}>{loading ? "Logging in..." : "Login"}</button>
      </form>
      <div className="social-login">
        <button onClick={() => handleSocial("Google")}>Sign in with Google</button>
        <button onClick={() => handleSocial("Facebook")}>Sign in with Facebook</button>
        <button onClick={() => handleSocial("Apple")}>Sign in with Apple</button>
        <button onClick={() => handleSocial("Twitter")}>Sign in with Twitter</button>
      </div>
      <div className="msg">{msg}</div>
    </div>
  );
}
