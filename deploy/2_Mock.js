module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    const MockUniV3SpotPrice = await deploy("MockUniV3SpotPrice", {
        from: deployer,
        args: ["0x86fd51Ad76226A93daB9B1fF02fe80cB53A1b1c2"], // address of UniV3SpotPrice, change if re-deploying UniV3SpotPrice
        log: true
    });

};
module.exports.tags = ['MockUniV3SpotPrice'];