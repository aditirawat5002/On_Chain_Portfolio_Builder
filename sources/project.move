module MyModule::PortfolioBuilder {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::string::String;
    use std::vector;

    /// Struct representing a user's portfolio
    struct Portfolio has store, key {
        assets: vector<String>,     // List of asset names/symbols
        amounts: vector<u64>,       // Corresponding amounts for each asset
        total_value: u64,          // Total portfolio value in APT
    }

    /// Function to create a new portfolio for a user
    public fun create_portfolio(owner: &signer) {
        let portfolio = Portfolio {
            assets: vector::empty<String>(),
            amounts: vector::empty<u64>(),
            total_value: 0,
        };
        move_to(owner, portfolio);
    }

    /// Function to add an asset to the portfolio by depositing APT
    public fun add_asset(
        owner: &signer, 
        asset_name: String, 
        amount: u64, 
        apt_deposit: u64
    ) acquires Portfolio {
        let owner_addr = signer::address_of(owner);
        let portfolio = borrow_global_mut<Portfolio>(owner_addr);
        
        // Deposit APT to represent the asset purchase
        let deposit = coin::withdraw<AptosCoin>(owner, apt_deposit);
        coin::deposit<AptosCoin>(owner_addr, deposit);
        
        // Add asset to portfolio
        vector::push_back(&mut portfolio.assets, asset_name);
        vector::push_back(&mut portfolio.amounts, amount);
        portfolio.total_value = portfolio.total_value + apt_deposit;
    }
}