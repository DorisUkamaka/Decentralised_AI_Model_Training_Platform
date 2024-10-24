;; AI Model Training Platform - Main Contract
;; Handles user registration, compute contributions, and token rewards

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-registered (err u101))
(define-constant err-already-registered (err u102))
(define-constant err-invalid-amount (err u103))

;; Data Variables
(define-data-var minimum-contribution uint u100)
(define-data-var reward-rate uint u10)  ;; tokens per compute unit
(define-data-var total-compute-power uint u0)

;; Data Maps
(define-map Users principal 
  {
    compute-power: uint,
    total-rewards: uint,
    is-active: bool,
    registration-time: uint
  }
)

(define-map Contributions principal 
  {
    last-contribution: uint,
    contribution-count: uint
  }
)

;; Check if user is registered
(define-read-only (is-user-registered (user principal))
  (is-some (map-get? Users user)))

;; Get user's contribution count
(define-read-only (get-contribution-count (user principal))
  (get contribution-count (default-to 
    {last-contribution: u0, contribution-count: u0}
    (map-get? Contributions user))))

(define-read-only (get-user-total-rewards (user principal))
  (get total-rewards (default-to 
    {compute-power: u0, total-rewards: u0, is-active: false, registration-time: u0}
    (map-get? Users user))))

(define-private (update-user-compute-power (user principal) (amount uint))
  (let ((current-data (unwrap-panic (map-get? Users user))))
    (map-set Users user (merge current-data {
      compute-power: (+ (get compute-power current-data) amount)
    }))
    (var-set total-compute-power (+ (var-get total-compute-power) amount))))

;; Update user's rewards
(define-private (update-user-rewards (user principal) (amount uint))
  (let ((current-data (unwrap-panic (map-get? Users user))))
    (map-set Users user (merge current-data {
      total-rewards: (+ (get total-rewards current-data) amount)
    }))))

;; Calculate rewards for contribution
(define-private (calculate-rewards (amount uint))
  (* amount (var-get reward-rate)))

;; Reward user for contribution
(define-private (reward-user (user principal) (amount uint))
  (let ((rewards (calculate-rewards amount)))
    (update-user-rewards user rewards)
    rewards))

;; Get pending rewards
(define-read-only (get-pending-rewards (user principal))
  (let ((user-data (unwrap-panic (map-get? Users user))))
    (if (get is-active user-data)
        (calculate-rewards (get compute-power user-data))
        u0)))

;; Register new user
(define-public (register-user)
  (let ((user tx-sender))
    (if (is-user-registered user)
        err-already-registered
        (begin
          (map-set Users user {
            compute-power: u0,
            total-rewards: u0,
            is-active: true,
            registration-time: block-height
          })
          (ok true)))))

;; Contribute compute power
(define-public (contribute-compute (amount uint))
  (let ((user tx-sender))
    (if (and (is-user-registered user)
             (>= amount (var-get minimum-contribution)))
        (begin
          (map-set Contributions user {
            last-contribution: block-height,
            contribution-count: (+ (get-contribution-count user) u1)
          })
          (update-user-compute-power user amount)
          (reward-user user amount)
          (ok true))
        err-invalid-amount)))

;; Claim rewards
(define-public (claim-rewards)
  (let ((user tx-sender)
        (current-rewards (get-pending-rewards user)))
    (if (> current-rewards u0)
        (begin
          (try! (as-contract (stx-transfer? current-rewards contract-owner user)))
          (update-user-rewards user current-rewards)
          (ok current-rewards))
        (ok u0))))


;; Admin Functions

;; Update minimum contribution requirement
(define-public (set-minimum-contribution (new-minimum uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (var-set minimum-contribution new-minimum)
    (ok true)))

;; Update reward rate
(define-public (set-reward-rate (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (var-set reward-rate new-rate)
    (ok true)))

;; Deactivate user
(define-public (deactivate-user (user principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (let ((current-data (unwrap-panic (map-get? Users user))))
      (map-set Users user (merge current-data {
        is-active: false
      }))
      (ok true))))

