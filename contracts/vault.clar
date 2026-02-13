;; Simple Vault Contract

(define-map vaults { user: principal } { balance: uint })

;; Deposit to vault
(define-public (deposit (amount uint))
  (let ((current (default-to u0 (get balance (map-get? vaults { user: tx-sender })))))
    (map-set vaults { user: tx-sender } { balance: (+ current amount) })
    (ok "Deposited")
  )
)

;; Withdraw from vault
(define-public (withdraw (amount uint))
  (let ((current (default-to u0 (get balance (map-get? vaults { user: tx-sender })))))
    (if (>= current amount)
        (begin
          (map-set vaults { user: tx-sender } { balance: (- current amount) })
          (ok "Withdrawn")
        )
        (err u101)
    )
  )
)

;; Check balance
(define-read-only (get-balance (user principal))
  (default-to u0 (get balance (map-get? vaults { user }))))
