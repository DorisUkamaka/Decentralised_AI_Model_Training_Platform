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
