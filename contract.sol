pragma solidity ^0.4.6;

contract WinnerTakesAll {
    uint public minimumEntryFee;
    uint public deadlineProjects;
    uint public deadlineCampaign;
    bool campaignFinished;
    
    uint totalWallet;
    
    uint curWinnerAmount;
    address curWinnerProject;
    
    struct Project {
        bool initialized;
        uint amount;
        string url;
        string name;
    }
    
    mapping(address => Project) projects;
    
    function WinnerTakesAll(uint _minimumEntryFee, uint _durationProjects, uint _durationCampaign) public {
        if (_durationCampaign <= _durationProjects) {
            throw;
        }
        minimumEntryFee = _minimumEntryFee;
        deadlineProjects = now + _durationProjects* 1 seconds;
        deadlineCampaign = now + _durationCampaign * 1 seconds;
        campaignFinished = false;
    }
    function submitProject(string name, string url) payable public returns (bool success) {
    	if (campaignFinished)
    		throw;

        if (msg.value < minimumEntryFee)
            throw;
        if (!projects[msg.sender].initialized)
        {
            projects[msg.sender] = Project(true, 0, url, name);
            totalWallet += msg.value;
        }
        else
            throw;
        return true;
    }
    function supportProject(address addr) payable public returns (bool success) {
    	if (campaignFinished)
    		throw;
        if (!projects[msg.sender].initialized)
        {
        	projects[addr].amount += msg.value;
        	totalWallet += msg.value;
        	if (projects[addr].amount > curWinnerAmount)
        		curWinnerProject = addr;
    	}
    	else 
    		throw;
        return true;
    }
    function finish() {
        campaignFinished = true;
    	if (curWinnerProject != 0)
    	{
    		if (curWinnerProject.send(totalWallet))
    			totalWallet = 0;
    	}
    	else
    		throw;
    }
}