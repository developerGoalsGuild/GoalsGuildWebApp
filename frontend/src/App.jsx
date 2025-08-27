import React from "react";
import { Outlet, Link } from "react-router-dom";
import "./App.css";

export default function App() {
  return (
    <div className="app-container">
      <header>
        <img src="/logo.svg" alt="Goals Guild Logo" className="logo" />
        <h1>Goals Guild</h1>
        <nav>
          <Link to="/signin">Sign In</Link>
          <Link to="/register">Sign Up</Link>
          <Link to="/profile">Profile</Link>
        </nav>
      </header>
      <main>
        <Outlet />
      </main>
    </div>
  );
}
