# 🌟 Ethereum Balance Checker dApp 🌟

A simple and elegant decentralized application for checking your Ethereum wallet balance.

## ✨ Features

- 🔗 Connect to Ethereum wallets (MetaMask, WalletConnect)
- 💰 View your ETH balance in real-time
- 🚀 Fast and responsive interface
- 🖌️ Clean, modern UI with TailwindCSS
- 📱 Mobile-friendly design

## 🛠️ Tech Stack

- **[Nuxt.js](https://nuxt.com/)** - Vue.js framework for building modern web applications
- **[Wagmi](https://wagmi.sh/)** - React/Vue hooks for Ethereum
- **[Viem](https://viem.sh/)** - TypeScript interface for Ethereum
- **[TailwindCSS](https://tailwindcss.com/)** - Utility-first CSS framework
- **[TanStack Query](https://tanstack.com/query)** - Powerful data fetching library
- **[WalletConnect](https://walletconnect.com/)** - Open protocol for connecting wallets

## 📋 Prerequisites

- Node.js (v16+)
- npm or yarn
- MetaMask extension or compatible wallet app

## 🚀 Getting Started

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/eth-balance-checker.git
cd eth-balance-checker

# Install dependencies
npm install
# or
yarn install
```

### Configuration

1. Create a WalletConnect project ID at [WalletConnect Cloud](https://cloud.walletconnect.com/)
2. Add your project ID to `plugins/wagmi.js`:

```javascript
walletConnect({
  projectId: 'YOUR_WALLET_CONNECT_PROJECT_ID', // Replace this
}),
```

### Development

```bash
# Start development server
npm run dev
# or
yarn dev
```

Visit [http://localhost:3000](http://localhost:3000) in your browser.

### Build for Production

```bash
# Build for production
npm run build
# or
yarn build
```

## 📱 Usage

1. Visit the app in your browser
2. Click "Connect with MetaMask" or "Connect with WalletConnect"
3. Accept the connection in your wallet
4. View your ETH balance displayed on the screen
5. Click "Refresh Balance" to update the balance data

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is [MIT](LICENSE) licensed.

## 🙏 Acknowledgments

- The Ethereum community
- Wagmi and Viem developers
- Nuxt.js team
- TailwindCSS maintainers

---

Made with ❤️ by [doublep](https://github.com/doubleppereira)
