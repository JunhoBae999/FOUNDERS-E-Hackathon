const { assert } = require('chai')

//import the contract
const RemainToken = artifacts.require('./RemainToken.sol')

require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('RemainToken',(accounts) => {
    let contract

    before(async() => {
        contract = await RemainToken.deployed()
    })


    describe('deployment',async => {
        it('deploys successfully',async() => {
            const address = contract.address
            console.log(address)
            assert.notEqual(address,'')

            assert.notEqual(address,0x0)
            assert.notEqual(address,'')
            assert.notEqual(address,null)
            assert.notEqual(address,undefined)

        })


    })

    describe('minting',async() => {

        it('creates a new token', async() => {
            const result = await contract.mint("Seoul")
            const totalSupply = await contract.totalSupply();
            
            //SUCCESS
            assert.equal(totalSupply,1)
            console.log(result)

            const event = result.logs[0].args
            assert.equal(event.tokenId.toNumber(),1,'id is correct')
            assert.equal(event.from,'0x00000000000000000000000000000000')
            assert.equal(event.to,accounts[0],'to is correct')
            
            //FALIURE: cannot get same locations
            await contract.mint("Seoul").should.be.rejected;

        })
        
        describe('indexing',async()=> {
            it('lists colors', async() => {
                await contract.mint("Hanam")
                await contract.mint("Donghae")
                await contract.mint("Hyehwa")

                const totalSupply = await contract.totalSupply()

                let location
                let result = []

                for(var i =1; i<=totalSupply;i++) {
                    location = await contract.locations(i-1)
                    result.push(location)
                }
                let expected = ['Seoul','Hanam','Donghae','Hyehwa']
                assert.equal(result.join(','),expected.join(','))
            })


        })



    })

})