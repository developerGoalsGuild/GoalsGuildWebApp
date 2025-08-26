# GoalsGuild Flutter Web Application

A modern web application for goal setting, social collaboration, and company service integration, built with Flutter Web and AWS-powered backend.

---

## 1. High-Level Architecture Diagram

```
+-------------------+         +-------------------+         +-------------------+
|                   |         |                   |         |                   |
|   Flutter Web     | <-----> |  AWS API Gateway  | <-----> |  AWS Lambda /     |
|   Application     |  REST   |  (RESTful APIs)   |  REST   |  Microservices    |
|                   |         |                   |         |  (Dockerized)     |
+-------------------+         +-------------------+         +-------------------+
        |                             |                               |
        |                             |                               |
        |                             v                               v
        |                   +-------------------+         +-------------------+
        |                   |  Cognito (Auth)   |         |  DynamoDB/RDS     |
        |                   +-------------------+         +-------------------+
        |                             |                               |
        |                             v                               v
        |                   +-------------------+         +-------------------+
        |                   |  3rd Party APIs   |         |  Payment Gateway  |
        |                   | (Google, Apple,   |         |  (Stripe, etc.)   |
        |                   |  Facebook, Twitter|         +-------------------+
        |                   +-------------------+
```

**Key Points:**
- All frontend-backend communication is via AWS API Gateway (REST).
- Authentication is handled by Cognito and a Dockerized user microservice.
- Social logins use Cognito federated identities.
- Real-time messaging and payments are proxied through API Gateway.
- Company and user data stored in managed AWS databases.

---

## 2. Detailed Feature List

### 2.1 User Registration & Authentication
- Social login: Apple, Google, Facebook, Twitter (via Cognito).
- Secure registration, login, logout, and session management.
- User profile creation and management.
- JWT-based authentication for API calls.

### 2.2 Goal Management (NLP-based)
- Create, edit, delete goals using NLP principles (well-formed outcomes, etc.).
- Break goals into tasks/subtasks with due dates.
- Mark tasks as complete/incomplete.
- View progress and history.

### 2.3 Social Features
- Search for users with similar goals (by tags, NLP categories, etc.).
- Follow/unfollow users.
- Direct messaging (real-time or near real-time).
- Request and offer help (free or paid).
- "Adopt" a user: encourage, mentor, or support their goals.
- Notifications for follows, messages, help requests, and adoptions.

### 2.4 Paid Assistance
- Users can offer paid help (set rates, accept payments).
- Secure payment integration (Stripe or similar via backend).
- Transaction history and receipts.

### 2.5 Company Interaction
- Company registration and profile management.
- Companies can list services related to goals/tasks.
- Users can browse, search, and purchase company services.
- Company-user messaging and support.

### 2.6 General
- Responsive, accessible UI for web browsers.
- Secure data handling and privacy compliance.
- Error handling, loading states, and user feedback.

---

## 3. Prioritized Development Roadmap

### Phase 1: Foundation
- Project setup (Flutter web, CI/CD, linting, theming).
- Core authentication (Cognito, social logins).
- User profile management.
- Secure API integration (JWT, HTTPS).

### Phase 2: Goal Management
- NLP-based goal creation and editing.
- Task breakdown, due dates, and progress tracking.
- UI for goal/task management.

### Phase 3: Social Features
- User search and follow system.
- Messaging (start with polling, upgrade to websockets if possible).
- Help requests and adoption features.
- Notifications.

### Phase 4: Paid Assistance & Payments
- Payment integration (Stripe or similar via backend).
- Offer/request paid help.
- Transaction management.

### Phase 5: Company Services
- Company registration and service listing.
- User-company interaction and service purchase.

### Phase 6: Polish & Scale
- Accessibility improvements.
- Performance optimization.
- Advanced notifications.
- Real-time upgrades (websockets, push notifications).
- Documentation and deployment.

---

## 4. Recommendations

### 4.1 Scalable State Management
- Use [Riverpod](https://riverpod.dev/) or [Bloc](https://bloclibrary.dev/) for scalable, testable state management.
- Modularize state by feature (auth, goals, social, payments, etc.).
- Use immutable data models and DTOs for API integration.

### 4.2 Secure API Integration
- All API calls via HTTPS to AWS API Gateway.
- Use Cognito JWT tokens for authentication/authorization.
- Store tokens securely (memory or secure storage, not localStorage).
- Handle token refresh and session expiry gracefully.
- Validate all user input before sending to backend.

### 4.3 Real-Time Messaging
- Start with REST polling for messages (simple, reliable).
- Upgrade to WebSockets via AWS API Gateway (if supported) for real-time.
- Use message queues (SQS/SNS) on backend for scalability.
- Implement optimistic UI updates and error handling.

### 4.4 Payments
- Integrate Stripe (or similar) via backend API (never expose keys in frontend).
- Use PCI-compliant flows (redirects, hosted fields).
- Handle payment errors, refunds, and receipts.
- Store only non-sensitive payment metadata in frontend.

### 4.5 Best Practices
- Use Flutter's built-in accessibility features.
- Test on all major browsers and screen sizes.
- Use semantic HTML and ARIA roles for web accessibility.
- Modularize codebase for maintainability.
- Write unit and integration tests for critical flows.

---

## 5. References & Further Reading

- [Flutter Web Documentation](https://docs.flutter.dev/platform-integration/web)
- [AWS API Gateway](https://docs.aws.amazon.com/apigateway/)
- [AWS Cognito](https://docs.aws.amazon.com/cognito/)
- [Riverpod State Management](https://riverpod.dev/)
- [Stripe for Payments](https://stripe.com/docs)
- [Web Accessibility](https://www.w3.org/WAI/standards-guidelines/wcag/)

---

## 6. Contact & Support

For questions, issues, or contributions, please open an issue or contact the project maintainer.

---
