package com.goim.bootstrap;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Date;
import java.util.Observable;
import java.util.Observer;

public class PushClient extends AbstractBlockingClient {

	public PushClient(InetAddress server, int port ,Integer uid ,String game) {
		super(server, port , uid, game);
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void heartBeatReceived() {
		// TODO Auto-generated method stub
		System.out.println("heartBeatReceived ...");
	}
	

	@Override
	protected void authSuccess() {
		// TODO Auto-generated method stub
		System.out.println("authSuccess ...");
	}
	
	@Override
	protected void messageReceived(Long packageLength,Long headLength,Long version,Long operation,Long sequenceId,String message) {
		// TODO Auto-generated method stub
		StringBuilder sb = new StringBuilder();
		sb.append("-----------------------------" + new Date().getTime()+ "\n");
		sb.append("headLength:" + headLength + "\n");
		sb.append("version:" + version + "\n");
		sb.append("operation:" + operation + "\n");
		sb.append("sequenceId:" + sequenceId + "\n");
		sb.append("message:" + message + "\n");
		sb.append("-----------------------------");
		System.out.println(sb.toString());
		
	}
	
	@Override
	protected void messageReceived(String message) {
		// TODO Auto-generated method stub
		StringBuilder sb = new StringBuilder();
		sb.append(new Date().getTime() + "," + uid + ",message:" + message);
		System.out.println(sb.toString());
		
	}

	@Override
	protected void connected(boolean alreadyConnected) {
		// TODO Auto-generated method stub
		System.out.println("alreadyConnected is " + alreadyConnected);
	}

	@Override
	protected void disconnected() {
		// TODO Auto-generated method stub
		System.out.println("disconnected....... ");

	}
	
	class Listener implements Observer {
	     @Override
	     public void update(Observable o, Object arg) {
	         System.out.println( "PushClient 死机" );
	         PushClient pc = new PushClient(getServer(),getPort(),uid,game);
	         pc.addObserver( this );
	         new Thread(pc).start();
	         System.out.println( "PushClient 重启" );
	     }
	}
	
	public static void main(String[] args) throws UnknownHostException {
		PushClient cb = new PushClient(InetAddress.getByName("10.160.61.129"), 8080 , 1, "game");
		Listener listen = cb.new Listener();
        cb.addObserver(listen);
		Thread t = new Thread(cb);
		t.start();
	}

}
