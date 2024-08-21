resource "tls_private_key" "cm_ca_private_key" {
  algorithm = "RSA"
}


resource "local_file" "cm_ca_key" {
  content  = tls_private_key.cm_ca_private_key.private_key_pem
  filename = "${path.module}/certs/webserverCA.key"
}


resource "tls_self_signed_cert" "cm_ca_cert" {
  private_key_pem = tls_private_key.cm_ca_private_key.private_key_pem

  is_ca_certificate = true

  subject {
    country             = "EU"
    province            = "France"
    locality            = "Paris"
    common_name         = "Web Server Root CA"
    organization        = "My Web Server Software Solutions Pvt Ltd."
    organizational_unit = "My Web Server Root Certification Auhtority"
  }

  validity_period_hours = 43800 //  1825 days or 5 years

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}

resource "local_file" "cm_ca_cert" {
  content  = tls_self_signed_cert.cm_ca_cert.cert_pem
  filename = "${path.module}/certs/webserver.cert"
}

# Create private key for server certificate 
resource "tls_private_key" "cm_internal" {
  algorithm = "RSA"
}

resource "local_file" "cm_internal_key" {
  content  = tls_private_key.cm_internal.private_key_pem
  filename = "${path.module}/certs/dev.webserver.key"
}


# Create CSR for for server certificate 
resource "tls_cert_request" "cm_internal_csr" {

  private_key_pem = tls_private_key.cm_internal.private_key_pem

  dns_names = ["dev.webserver.internal"]

  subject {
    country             = "EU"
    province            = "France"
    locality            = "Paris"
    common_name         = "Web Server Internal Development "
    organization        = "Technologies Pvt Ltd"
    organizational_unit = "Development"
  }
}

# Sign Server Certificate by Private CA 
resource "tls_locally_signed_cert" "cm_internal" {
  // CSR by the development servers
  cert_request_pem = tls_cert_request.cm_internal_csr.cert_request_pem
  // CA Private key 
  ca_private_key_pem = tls_private_key.cm_ca_private_key.private_key_pem
  // CA certificate
  ca_cert_pem = tls_self_signed_cert.cm_ca_cert.cert_pem

  validity_period_hours = 43800

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth",
  ]
}

resource "local_file" "cm_internal_cert" {
  content  = tls_locally_signed_cert.cm_internal.cert_pem
  filename = "${path.module}/certs/dev.webserver.cert"
}
