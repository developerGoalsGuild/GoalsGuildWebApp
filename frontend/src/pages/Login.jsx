import React from "react";
import { useNavigate } from "react-router-dom";

export default function Login() {
  const navigate = useNavigate();
  // This page is now deprecated, redirect to /signin
  React.useEffect(() => {
    navigate("/signin", { replace: true });
  }, [navigate]);
  return null;
}
