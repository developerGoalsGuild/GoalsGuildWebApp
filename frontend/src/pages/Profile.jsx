import React, { useEffect, useState } from "react";
import axios from "axios";

export default function Profile() {
  const [profile, setProfile] = useState(null);
  const [displayName, setDisplayName] = useState("");
  const [msg, setMsg] = useState("");

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const token = localStorage.getItem("access_token");
        const res = await axios.get("/api/profile", {
          headers: { Authorization: `Bearer ${token}` }
        });
        setProfile(res.data);
        setDisplayName(res.data.display_name);
      } catch (err) {
        setMsg("Failed to load profile: " + (err.response?.data?.detail || err.message));
      }
    };
    fetchProfile();
  }, []);

  const handleUpdate = async (e) => {
    e.preventDefault();
    try {
      const token = localStorage.getItem("access_token");
      const res = await axios.put("/api/profile", { display_name: displayName }, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setProfile(res.data);
      setMsg("Profile updated!");
    } catch (err) {
      setMsg("Update failed: " + (err.response?.data?.detail || err.message));
    }
  };

  if (!profile) return <div>Loading...</div>;

  return (
    <div className="profile medieval-card">
      <h2>Profile</h2>
      <form onSubmit={handleUpdate}>
        <label>Email</label>
        <input value={profile.email} disabled />
        <label>Display Name</label>
        <input value={displayName} onChange={e => setDisplayName(e.target.value)} />
        <button type="submit">Update</button>
      </form>
      <div className="msg">{msg}</div>
    </div>
  );
}
