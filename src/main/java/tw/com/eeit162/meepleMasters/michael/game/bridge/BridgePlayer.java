package tw.com.eeit162.meepleMasters.michael.game.bridge;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class BridgePlayer {
	
	private Integer playerNumber;
	
	private String name;
	
	private String Email;
	
	private Integer bridgeDegree;
	
	private Set<Integer> handCardSet = new TreeSet<>();
	
	private List<Integer> handCardList = new ArrayList<>();
	
	private Integer wonTricks;
	
	private Integer team;//1紅隊，2藍隊
	
	

	public BridgePlayer() {
	}
	
	public BridgePlayer(Integer playerNumber) {
		this.playerNumber = playerNumber;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return Email;
	}

	public void setEmail(String email) {
		Email = email;
	}

	public Integer getBridgeDegree() {
		return bridgeDegree;
	}

	public void setBridgeDegree(Integer bridgeDegree) {
		this.bridgeDegree = bridgeDegree;
	}


	public Integer getWonTricks() {
		return wonTricks;
	}

	public void setWonTricks(Integer wonTricks) {
		this.wonTricks = wonTricks;
	}

	public Integer getTeam() {
		return team;
	}

	public void setTeam(Integer team) {
		this.team = team;
	}

	public Integer getPlayerNumber() {
		return playerNumber;
	}

	public void setPlayerNumber(Integer playerNumber) {
		this.playerNumber = playerNumber;
	}
	
	
	

	public Set<Integer> getHandCardSet() {
		return handCardSet;
	}

	public void setHandCardSet(Set<Integer> handCardSet) {
		this.handCardSet = handCardSet;
	}

	public List<Integer> getHandCardList() {
		return handCardList;
	}

	public void setHandCardList(List<Integer> handCardList) {
		this.handCardList = handCardList;
	}

	@Override
	public String toString() {
		return "BridgePlayer [playerNumber=" + playerNumber + ", name=" + name + ", Email=" + Email + ", bridgeDegree="
				+ bridgeDegree + ", handCardSet=" + handCardSet + ", handCardList=" + handCardList + ", wonTricks="
				+ wonTricks + ", team=" + team + "]";
	}

	
	
	
	
	
	
	

}