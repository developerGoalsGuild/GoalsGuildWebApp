# Terraform Environment Variable Defaults

This directory contains Terraform variable definitions and environment-specific default value files for the GoalsGuild infrastructure.

## Structure

- `variables.tf`: Core variable declarations without environment-specific defaults.
- `dev.tfvars`: Default variable values for the development environment.
- `uat.tfvars`: Default variable values for the UAT environment.
- `prod.tfvars`: Default variable values for the production environment.

## Usage

To apply Terraform configuration with environment-specific defaults, use the `-var-file` option:

```bash
terraform apply -var-file=dev.tfvars
terraform apply -var-file=uat.tfvars
terraform apply -var-file=prod.tfvars
```

## Overriding Defaults

- Variables can be overridden by environment variables prefixed with `TF_VAR_`.
- Sensitive values like `jwt_secret` should ideally be sourced from secure stores such as AWS Parameter Store or Vault.
- The `goalsguild_parameter_store` module can be used to manage secrets and configuration parameters centrally.

## Notes

- Keep sensitive values out of version control.
- Update the `.gitignore` to exclude any local override files containing secrets.
- Use this modular approach to maintain clear separation between variable declarations and environment-specific values.
