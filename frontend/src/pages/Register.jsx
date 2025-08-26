import React, { useState } from "react";
import axios from "axios";

export default function Register() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [displayName, setDisplayName] = useState("");
  const [msg, setMsg] = useState("");
  const [loading, setLoading] = useState(false);

  const handleRegister = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMsg("");
    try {
      await axios.post("/api/register", { email, password, display_name: displayName });
      setMsg("Registration successful! Please login.");
      setEmail("");
      setPassword("");
      setDisplayName("");
    } catch (err) {
      setMsg("Registration failed: " + (err.response?.data?.detail || err.message));
    }
    setLoading(false);
  };

  return (
    <div className="register medieval-card">
      <h2>Register</h2>
      <form onSubmit={handleRegister}>
        <label>Email</label>
        <input value={email} onChange={e => setEmail(e.target.value)} required />
        <label>Password</label>
        <input type="password" value={password} onChange={e => setPassword(e.target.value)} required />
        <label>Display Name</label>
        <input value={displayName} onChange={e => setDisplayName(e.target.value)} />
        <button type="submit" disabled={loading}>{loading ? "Registering..." : "Register"}</button>
      </form>
      <div className="msg">{msg}</div>
    </div>
  );
}
