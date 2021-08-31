module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    const OracleLibrary = await deploy("OracleLibrary", {
        from: deployer,
        log: true
    });

    const PoolAddress = await deploy("PoolAddress", {
        from: deployer,
        log: true
    });

    await deploy('UniV3SpotPrice', {
        from: deployer,
        log: true,
        libraries: {
            OracleLibrary: OracleLibrary.address,
            PoolAddress: PoolAddress.address
        }
    });
};
module.exports.tags = ['UniV3SpotPrice'];