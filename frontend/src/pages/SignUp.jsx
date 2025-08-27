import React, { useState } from "react";
import "./SignUp.css";

const initialState = {
  fullName: "",
  email: "",
  password: "",
  confirmPassword: "",
};

const initialErrors = {
  fullName: "",
  email: "",
  password: "",
  confirmPassword: "",
};

function validateEmail(email) {
  // Simple RFC 5322 compliant regex
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function validatePassword(password) {
  // At least 8 chars, 1 uppercase, 1 lowercase, 1 number
  return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$/.test(password);
}

export default function SignUp() {
  const [fields, setFields] = useState(initialState);
  const [errors, setErrors] = useState(initialErrors);
  const [submitted, setSubmitted] = useState(false);
  const [formMsg, setFormMsg] = useState("");
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    setFields({ ...fields, [e.target.name]: e.target.value });
    setErrors({ ...errors, [e.target.name]: "" });
  };

  const validate = () => {
    const newErrors = { ...initialErrors };
    if (!fields.fullName.trim()) newErrors.fullName = "Full name is required.";
    if (!fields.email.trim()) newErrors.email = "Email is required.";
    else if (!validateEmail(fields.email)) newErrors.email = "Enter a valid email address.";
    if (!fields.password) newErrors.password = "Password is required.";
    else if (!validatePassword(fields.password))
      newErrors.password =
        "Password must be at least 8 characters, include an uppercase letter, a lowercase letter, and a number.";
    if (!fields.confirmPassword) newErrors.confirmPassword = "Please confirm your password.";
    else if (fields.password !== fields.confirmPassword)
      newErrors.confirmPassword = "Passwords do not match.";
    setErrors(newErrors);
    return Object.values(newErrors).every((v) => !v);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSubmitted(true);
    setFormMsg("");
    if (!validate()) return;
    setLoading(true);
    // Simulate API call
    setTimeout(() => {
      setLoading(false);
      setFormMsg("Registration successful! Please sign in.");
      setFields(initialState);
      setSubmitted(false);
    }, 1200);
  };

  return (
    <div className="signup-container">
      <form className="signup-form" onSubmit={handleSubmit} noValidate aria-labelledby="signup-title">
        <h2 id="signup-title">Create Your Account</h2>
        <div className="form-group">
          <label htmlFor="fullName">Full Name<span aria-hidden="true">*</span></label>
          <input
            id="fullName"
            name="fullName"
            type="text"
            autoComplete="name"
            value={fields.fullName}
            onChange={handleChange}
            aria-invalid={!!errors.fullName}
            aria-describedby={errors.fullName ? "fullName-error" : undefined}
            required
          />
          {errors.fullName && (
            <span className="error" id="fullName-error" role="alert">
              {errors.fullName}
            </span>
          )}
        </div>
        <div className="form-group">
          <label htmlFor="email">Email Address<span aria-hidden="true">*</span></label>
          <input
            id="email"
            name="email"
            type="email"
            autoComplete="email"
            value={fields.email}
            onChange={handleChange}
            aria-invalid={!!errors.email}
            aria-describedby={errors.email ? "email-error" : undefined}
            required
          />
          {errors.email && (
            <span className="error" id="email-error" role="alert">
              {errors.email}
            </span>
          )}
        </div>
        <div className="form-group">
          <label htmlFor="password">Password<span aria-hidden="true">*</span></label>
          <input
            id="password"
            name="password"
            type="password"
            autoComplete="new-password"
            value={fields.password}
            onChange={handleChange}
            aria-invalid={!!errors.password}
            aria-describedby={errors.password ? "password-error" : undefined}
            required
          />
          {errors.password && (
            <span className="error" id="password-error" role="alert">
              {errors.password}
            </span>
          )}
        </div>
        <div className="form-group">
          <label htmlFor="confirmPassword">Confirm Password<span aria-hidden="true">*</span></label>
          <input
            id="confirmPassword"
            name="confirmPassword"
            type="password"
            autoComplete="new-password"
            value={fields.confirmPassword}
            onChange={handleChange}
            aria-invalid={!!errors.confirmPassword}
            aria-describedby={errors.confirmPassword ? "confirmPassword-error" : undefined}
            required
          />
          {errors.confirmPassword && (
            <span className="error" id="confirmPassword-error" role="alert">
              {errors.confirmPassword}
            </span>
          )}
        </div>
        <button
          type="submit"
          className="signup-btn"
          disabled={loading}
          aria-busy={loading}
        >
          {loading ? "Registering..." : "Sign Up"}
        </button>
        {formMsg && <div className="form-msg success" role="status">{formMsg}</div>}
      </form>
    </div>
  );
}
