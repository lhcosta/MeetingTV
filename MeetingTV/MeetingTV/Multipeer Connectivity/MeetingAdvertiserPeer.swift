//
//  MeetingConnectionPeer.swift
//  MeetingTV
//
//  Created by Lucas Costa  on 26/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CloudKit

protocol MeetingConnectionPeerDelegate : AnyObject {
    func willReceiveMeeting(deviceName : String)
    func didReceiveMeeting(data : Data)
}

/// Conexão entre peers para o recebimento de dados enviados
/// - Author: Lucas Costa

class MeetingAdvertiserPeer: NSObject {
    
    //MARK:- Properties
    
    /// Delegate do eventos ocorridos na transação dos eventos entre os peers
    weak var delegate : MeetingConnectionPeerDelegate?
    
    /// Nome do tipo do serviço fornecido
    private let serviceType = "screen-meeting"

    /// Classe para receber pedidos de conexão
    private var serviceAdvertiser : MCNearbyServiceAdvertiser!
    
    /// Sessão para conexão entre os peers
    private var session : MCSession!
    
    /// Identificação do peer
    private var peer : MCPeerID!
    
    private var meeting : Meeting!
    
    //MARK:- Initializer
    override init() {
        super.init()
        
        self.peer = MCPeerID(displayName: UIDevice.current.name)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.peer, discoveryInfo: nil, serviceType: self.serviceType)
        self.session = MCSession(peer: self.peer, securityIdentity: nil, encryptionPreference: .required)
        
        self.session.delegate = self
        self.serviceAdvertiser.delegate = self        
    }
    
    /// Receber convites de browsers.
    func startAdvertisingPeer() {
        NSLog("%@", "Start to advertiser")
        self.serviceAdvertiser.startAdvertisingPeer()
    }

    /// Parar de receber convites de browsers.
    func stopAdvertiserPeer() {
        self.serviceAdvertiser.stopAdvertisingPeer()
        NSLog("%@", "Stop to advertiser")
    }
    

}

//MARK:- MCNearbyServiceAdvertiserDelegate
extension MeetingAdvertiserPeer : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "Receive invitation from peer \(peerID)")
        
        if session.connectedPeers.count > 0 {
            invitationHandler(false, self.session)
        } else {
            invitationHandler(true, self.session)
            self.delegate?.willReceiveMeeting(deviceName: peerID.displayName)
        }
        
    }  
    
} 

//MARK:- MCSessionDelegate
extension MeetingAdvertiserPeer : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //TODO:-
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //TODO:-
        //Data from Meeting
        self.delegate?.didReceiveMeeting(data: data)
        self.stopAdvertiserPeer()
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //TODO:-
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //TODO:-
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //TODO:-
    }
    
    
}
