module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "192.168.1.102",
      port: 8545,
      network_id: "*" // Match any network id
    }
  }
};
