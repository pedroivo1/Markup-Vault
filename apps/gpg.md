# GPG Encryption Protocols

## Symmetric Encryption (Password-Based)

This method utilizes a single shared secret to both lock and unlock the data.

```sh
# Encrypt an existing file with a password
gpg --symmetric --armor --output token file.txt

# Compact syntax for quick encryption
echo "password" | gpg -cao token
```

## Asymmetric Encryption (Public Key)

The standard for secure communication, utilizing the recipient's public key to ensure only they can access the message.

```sh
# Long-form flags with pipe input
echo "secret" | gpg -er "user@email.com" -ao token

# Short-form flags for existing files
gpg -ear "KEY_ID" -o token file.txt

# Input redirection for streamlined workflows
gpg --ear "User Name" -o token < file.txt
```

## Combined: Signed and Encrypted

The gold standard for professional security. This protocol ensures confidentiality while proving the sender's identity.

```sh
# Sign and encrypt using long-form flags
echo "signed message" | gpg -ser "recipient@email.com" -ao token

# The professional's choice: Compact 'SEA' syntax (Sign, Encrypt, Armor)
gpg -sear "recipient@email.com" -o token file.txt

# Explicitly defining both sender and receiver identities
gpg --local-user "me@email.com" -ser "him@email.com" -ao token file.txt
```

## Summary

| Flag (Short) | Flag (Long) | Function |
| :--- | :--- | :--- |
| **`-c`** | `--symmetric` | Enables **symmetric encryption** using a shared password. |
| **`-e`** | `--encrypt` | Enables **asymmetric encryption** using a recipient's public key. |
| **`-s`** | `--sign` | Creates a **digital signature** to prove the sender's identity. |
| **`-a`** | `--armor` | Encodes output in **ASCII text format** instead of binary. |
| **`-o`** | `--output` | Directs the result to a **specific filename** (e.g., `token`). |
| **`-r`** | `--recipient` | Identifies the **target user** by name or email for encryption. |
| **`-u`** | `--local-user` | Specifies which **private key** to use for signing the message. |
| **`-d`** | `--decrypt` | Initiates the **decryption process** for an encrypted file. |
| **`--verify`** | `--verify` | Checks the validity of a **digital signature** without decrypting. |

> **Pro Tip:** You can combine short flags into a single string. For example, `gpg -sea` performs **S**igning, **E**ncryption, and **A**rmoring all at once.

> **Pro Tip:** When clustering, ensure the flag that requires an argument (like `-o` or `-r`) is the final character in the cluster, or provide the argument immediately after the specific flag.
