// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RSAEncryption {
    uint256 private p = 61; // Prime number p
    uint256 private q = 53; // Prime number q
    uint256 private n = p * q; // Modulus n
    uint256 private phi = (p - 1) * (q - 1); // Euler's totient function

    uint256 private e = 17; // Public exponent e
    uint256 private d = 2753; // Private exponent d

    function encrypt(uint256 plaintext) external view returns (uint256) {
        require(plaintext < n, "Plaintext must be less than n");

        // RSA encryption: ciphertext = (plaintext^e) % n
        return modExp(plaintext, e, n);
    }

    // Modular exponentiation with base, exponent, and modulus
    function modExp(uint256 base, uint256 exponent, uint256 modulus) internal pure returns (uint256 result) {
        result = 1;
        while (exponent > 0) {
            if (exponent % 2 == 1) {
                result = (result * base) % modulus;
            }
            base = (base * base) % modulus;
            exponent /= 2;
        }
    }
}
