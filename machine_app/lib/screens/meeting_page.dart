import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

import '../providers/providers.dart';

class MeetingPage extends ConsumerStatefulWidget {
  const MeetingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeetingPageState();
}

class _MeetingPageState extends ConsumerState<MeetingPage>
    implements HMSUpdateListener {
  late HMSSDK hmsSDK;
  String userName = "host";
  // String authToken =
  //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJzaW9uIjoyLCJ0eXBlIjoiYXBwIiwiYXBwX2RhdGEiOm51bGwsImFjY2Vzc19rZXkiOiI2NDBhYjk2YWVkYzdjOGYzNjc0YzBkNjUiLCJyb2xlIjoiaG9zdCIsInJvb21faWQiOiI2NDNlODIyNDhhNzkzNzc1YjBmMmQxYTIiLCJ1c2VyX2lkIjoiMzM1Yjc3ZDMtYThkOC00MWQ4LWEwZTAtNTlkNzA3ZjM5MzNlIiwiZXhwIjoxNjgyMzY0OTMyLCJqdGkiOiI0YmNhZTgyZi1hNGM1LTQwZjktODlkYi05NWExMDlmNzFmZTQiLCJpYXQiOjE2ODIyNzg1MzIsImlzcyI6IjY0MGFiOTZhZWRjN2M4ZjM2NzRjMGQ2MyIsIm5iZiI6MTY4MjI3ODUzMiwic3ViIjoiYXBpIn0.9wpjbzsBHngeH6US91g0dNlsBXs98GSNv8FFIqKxMSE";
  Offset position = const Offset(5, 5);
  bool isJoinSuccessful = false;
  HMSPeer? localPeer, remotePeer;
  HMSVideoTrack? localPeerVideoTrack, remotePeerVideoTrack;
  @override
  void initState() {
    super.initState();
    initHMSSDK();
  }

//To know more about HMSSDK setup and initialization checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/install-the-sdk/hmssdk
  void initHMSSDK() async {
    hmsSDK = HMSSDK();
    await hmsSDK.build();
    hmsSDK.addUpdateListener(listener: this);
    hmsSDK.join(
      config:
          HMSConfig(authToken: ref.watch(hostIdProvider), userName: userName),
    );
  }

  @override
  void dispose() {
    remotePeer = null;
    remotePeerVideoTrack = null;
    localPeer = null;
    localPeerVideoTrack = null;
    super.dispose();
  }

  @override
  void onJoin({required HMSRoom room}) {
    room.peers?.forEach((peer) {
      if (peer.isLocal) {
        localPeer = peer;
        if (peer.videoTrack != null) {
          localPeerVideoTrack = peer.videoTrack;
        }
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
        }
      }
    });
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    if (update == HMSPeerUpdate.networkQualityUpdated) {
      return;
    }
    if (update == HMSPeerUpdate.peerJoined) {
      if (!peer.isLocal) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              remotePeer = peer;
            });
          });
        }
      }
    } else if (update == HMSPeerUpdate.peerLeft) {
      if (!peer.isLocal) {
        if (mounted) {
          setState(() {
            remotePeer = null;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            localPeer = null;
          });
        }
      }
    }
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      if (trackUpdate == HMSTrackUpdate.trackRemoved) {
        if (peer.isLocal) {
          if (mounted) {
            setState(() {
              localPeerVideoTrack = null;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              remotePeerVideoTrack = null;
            });
          }
        }
        return;
      }
      if (peer.isLocal) {
        if (mounted) {
          setState(() {
            localPeerVideoTrack = track as HMSVideoTrack;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            remotePeerVideoTrack = track as HMSVideoTrack;
          });
        }
      }
    }
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // Checkout the docs about handling onAudioDeviceChanged updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // Checkout the docs for handling the unmute request here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/track/remote-mute-unmute
  }

  @override
  void onHMSError({required HMSException error}) {
    // To know more about handling errors please checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/debugging/error-handling
  }

  @override
  void onMessage({required HMSMessage message}) {
    // Checkout the docs for chat messaging here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/chat
  }

  @override
  void onReconnected() {
    // Checkout the docs for reconnection handling here: https://www.100ms.live/docs/flutter/v2/how--to-guides/handle-interruptions/reconnection-handling
  }

  @override
  void onReconnecting() {
    // Checkout the docs for reconnection handling here: https://www.100ms.live/docs/flutter/v2/how--to-guides/handle-interruptions/reconnection-handling
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // Checkout the docs for handling the peer removal here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/peer/remove-peer
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // Checkout the docs for handling the role change request here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/peer/change-role#accept-role-change-request
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // Checkout the docs for room updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // Checkout the docs for handling the updates regarding who is currently speaking here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/show-audio-level
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: (remotePeerVideoTrack == null)
                          ? MediaQuery.of(context).size.height
                          : MediaQuery.of(context).size.height / 2,
                      crossAxisCount: 1),
                  children: [
                    if (remotePeerVideoTrack != null && remotePeer != null)
                      // peerTile(
                      //     Key(remotePeerVideoTrack?.trackId ?? "" "mainVideo"),
                      //     remotePeerVideoTrack,
                      //     remotePeer,
                      //     context),
                      peerTile(
                          Key(localPeerVideoTrack?.trackId ?? "" "mainVideo"),
                          localPeerVideoTrack,
                          localPeer,
                          context)
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          hmsSDK.leave();
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Colors.red.withAlpha(60),
                              blurRadius: 3.0,
                              spreadRadius: 5.0,
                            ),
                          ]),
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.call_end, color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          hmsSDK.switchCamera();
                          //Navigator.pop(context);
                        },
                        child: Container(
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Colors.red.withAlpha(60),
                              blurRadius: 3.0,
                              spreadRadius: 5.0,
                            ),
                          ]),
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.red,
                            child:
                                Icon(Icons.cameraswitch, color: Colors.white),
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('devicestate')
                            .doc('torch')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.data!.get('state')) {
                            HMSCameraControls.toggleFlash();
                          } else {
                            HMSCameraControls.toggleFlash();
                          }
                          return GestureDetector(
                            onTap: () {
                              HMSCameraControls.toggleFlash();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withAlpha(60),
                                    blurRadius: 3.0,
                                    spreadRadius: 5.0,
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.red,
                                child:
                                    Icon(Icons.flash_on, color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget peerTile(
      Key key, HMSVideoTrack? videoTrack, HMSPeer? peer, BuildContext context) {
    return Container(
      key: key,
      color: Colors.black,
      child: (videoTrack != null && !(videoTrack.isMute))
// To know more about HMSVideoView checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/overview
          ? HMSVideoView(
              track: videoTrack,
            )
          : Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(4),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 20.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Text(
                  peer?.name.substring(0, 1) ?? "D",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
    );
  }
}
