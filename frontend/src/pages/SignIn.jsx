import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

export default function SignIn() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [msg, setMsg] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleSignIn = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMsg("");
    try {
      const res = await axios.post("/api/login", { email, password });
      localStorage.setItem("access_token", res.data.access_token);
      setMsg("Sign in successful!");
      navigate("/profile");
    } catch (err) {
      setMsg("Sign in failed: " + (err.response?.data?.detail || err.message));
    }
    setLoading(false);
  };

  const handleSocial = (provider) => {
    window.location.href = `/api/login/social/${provider}`;
  };

  return (
    <div className="signin medieval-card">
      <h2>Sign In</h2>
      <form onSubmit={handleSignIn}>
        <label>Email</label>
        <input
          value={email}
          onChange={e => setEmail(e.target.value)}
          required
          autoComplete="username"
        />
        <label>Password</label>
        <input
          type="password"
          value={password}
          onChange={e => setPassword(e.target.value)}
          required
          autoComplete="current-password"
        />
        <button type="submit" disabled={loading}>
          {loading ? "Signing in..." : "Sign In"}
        </button>
      </form>
      <div className="social-login">
        <p>Or sign in with:</p>
        <button onClick={() => handleSocial("Google")}>Google</button>
        <button onClick={() => handleSocial("Facebook")}>Facebook</button>
        <button onClick={() => handleSocial("Apple")}>Apple</button>
        <button onClick={() => handleSocial("Twitter")}>Twitter</button>
      </div>
      <div className="msg">{msg}</div>
      <div className="switch-auth">
        <span>Don't have an account?</span>
        <button type="button" onClick={() => navigate("/register")}>Sign Up</button>
      </div>
    </div>
  );
}
