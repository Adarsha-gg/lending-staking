// Contract configuration
const CONTRACT_ADDRESS = "YOUR_CONTRACT_ADDRESS";
const CONTRACT_ABI = [
    "function stake(uint256 amount) external",
    "function withdraw() external",
    "function getStakedAmount(address user) external view returns (uint256)"
];

// Global variables
let provider;
let signer;
let contract;

// DOM Elements
const connectButton = document.getElementById('connectButton');
const walletInfo = document.getElementById('walletInfo');
const stakingControls = document.getElementById('stakingControls');
const stakeAmount = document.getElementById('stakeAmount');
const stakeButton = document.getElementById('stakeButton');
const withdrawButton = document.getElementById('withdrawButton');
const stakingInfo = document.getElementById('stakingInfo');

// Connect wallet function
async function connectWallet() {
    try {
        // Connect to MetaMask
        provider = new ethers.providers.Web3Provider(window.ethereum);
        await provider.send("eth_requestAccounts", []);
        signer = provider.getSigner();
        
        // Get user's address
        const address = await signer.getAddress();
        walletInfo.textContent = `Connected: ${address}`;
        
        // Initialize contract
        contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, signer);
        
        // Show staking controls
        stakingControls.style.display = 'block';
        
        // Update staking info
        updateStakingInfo();
    } catch (error) {
        console.error('Connection error:', error);
        walletInfo.textContent = 'Error connecting wallet';
    }
}

// Stake function
async function stake() {
    try {
        if (!stakeAmount.value) {
            alert('Please enter an amount to stake');
            return;
        }
        
        const amount = stakeAmount.value;
        // Disable stake button during transaction
        stakeButton.disabled = true;
        stakeButton.textContent = 'Staking...';
        
        const tx = await contract.stake(ethers.utils.parseEther(amount));
        await tx.wait();
        
        // Reset and update UI
        stakeAmount.value = '';
        updateStakingInfo();
    } catch (error) {
        console.error('Staking error:', error);
        alert('Error staking tokens');
    } finally {
        stakeButton.disabled = false;
        stakeButton.textContent = 'Stake';
    }
}

// Withdraw function
async function withdraw() {
    try {
        // Disable withdraw button during transaction
        withdrawButton.disabled = true;
        withdrawButton.textContent = 'Withdrawing...';
        
        const tx = await contract.withdraw();
        await tx.wait();
        
        updateStakingInfo();
    } catch (error) {
        console.error('Withdrawal error:', error);
        alert('Error withdrawing tokens');
    } finally {
        withdrawButton.disabled = false;
        withdrawButton.textContent = 'Withdraw';
    }
}

// Update staking info
async function updateStakingInfo() {
    try {
        const address = await signer.getAddress();
        const stakedAmount = await contract.getStakedAmount(address);
        stakingInfo.textContent = `Staked: ${ethers.utils.formatEther(stakedAmount)} ETH`;
    } catch (error) {
        console.error('Error updating staking info:', error);
        stakingInfo.textContent = 'Error loading staked amount';
    }
}

// Event Listeners
connectButton.addEventListener('click', connectWallet);
stakeButton.addEventListener('click', stake);
withdrawButton.addEventListener('click', withdraw);

// Listen for network changes
if (window.ethereum) {
    window.ethereum.on('chainChanged', () => {
        window.location.reload();
    });
    window.ethereum.on('accountsChanged', () => {
        window.location.reload();
    });
}