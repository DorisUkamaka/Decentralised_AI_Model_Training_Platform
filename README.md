# AI Model Training Platform Smart Contract

This project implements a smart contract for an AI Model Training Platform that allows users to contribute compute power, register, and claim token-based rewards based on their contributions. The contract also includes administrative functions to manage key settings.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Admin Functions](#admin-functions)
- [Testing](#testing)
- [License](#license)

## Features

### 1. **User Registration**
   - Users can register with the platform using the `register-user` function, which stores user details.

### 2. **Contribute Compute Power**
   - Registered users can contribute compute power using the `contribute-compute` function.
   - Contributions are recorded, and users are rewarded based on their compute power contributions.

### 3. **Reward System**
   - Users are automatically eligible for rewards after making contributions.
   - Functions include:
     - `calculate-rewards`: Computes rewards based on contributions.
     - `get-pending-rewards`: Fetches pending rewards for a user.
     - `claim-rewards`: Allows users to claim their rewards and transfer tokens.

### 4. **Admin Functions**
   - Contract owners can manage key contract settings, including:
     - `set-minimum-contribution`: Set the minimum compute power required for contribution.
     - `set-reward-rate`: Update the reward rate for contributions.
     - `deactivate-user`: Disable a user’s ability to contribute or claim rewards.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/DorisUkamaka/ai-model-training-platform.git
   cd ai-model-training-platform
   ```

2. Ensure you have [Clarinet](https://docs.hiro.so/clarinet) installed.

3. Run the project:
   ```bash
   clarinet check
   clarinet test
   ```

## Usage

### Register User
Users must register before contributing compute power. Use the following command:
```clarity
(register-user 'user-principal)
```

### Contribute Compute Power
Users can contribute their compute power and earn rewards:
```clarity
(contribute-compute 'user-principal compute-amount)
```

### Claim Rewards
Users can claim their pending rewards after a contribution:
```clarity
(claim-rewards 'user-principal)
```

### Fetch Pending Rewards
To get the pending rewards for a specific user:
```clarity
(get-pending-rewards 'user-principal)
```

## Admin Functions

### Set Minimum Contribution
Admins can set the minimum contribution level:
```clarity
(set-minimum-contribution new-minimum)
```

### Set Reward Rate
Admins can modify the reward rate for compute contributions:
```clarity
(set-reward-rate new-reward-rate)
```

### Deactivate User
Admins can deactivate a user, disabling their ability to contribute or claim rewards:
```clarity
(deactivate-user 'user-principal)
```

## Testing

1. Run all contract tests using:
   ```bash
   clarinet test
   ```
2. Test the following scenarios:
   - User registration and contribution flows.
   - Reward calculations and claims.
   - Admin functionalities like setting the minimum contribution and reward rate.
   
Tests are located in the `tests/` directory.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
