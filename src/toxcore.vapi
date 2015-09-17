/*
 *    tox-1.0.vapi
 *
 *    Copyright (C) 2013-2014  Venom authors and contributors
 *
 *    This file is part of Venom.
 *
 *    Venom is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    Venom is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with Venom.  If not, see <http://www.gnu.org/licenses/>.
 */
/**
*	This is the main toxcore.vapi
*	this file should contains the toxcore binding.
*/
[CCode (cheader_filename = "tox/tox.h", cprefix = "tox_")]
namespace Tox {
	[CCode (cprefix = "TOX_")]
	public const int DEFINED;
	[CCode (cprefix = "TOX_")]
	public const int VERSION_MAJOR;
	//[CCode (cprefix = "tox_")]
	//public int32 version_major(void);
	[CCode (cprefix = "TOX_")]
	public const int VERSION_MINOR;
	//[CCode (cprefix = "tox_")]
	//public int32 version_minor(void);
	[CCode (cprefix = "TOX_")]
	public const int VERSION_PATCH;
	//[CCode (cprefix = "tox_")]
	//public int32 version_patch(void);
	//[CCode (cprefix = "TOX_")]
	//public void VERSION_IS_API_COMPATIBLE(MAJOR, MINOR, PATCH);
	[CCode (cprefix = "tox_")]
	bool version_is_compatible(int32 major, int32 minor, int32 patch);
	//[CCode (cprefix = "TOX_")]
	//public void TOX_VERSION_REQUIRE(MAJOR, MINOR, PATCH);
	//[CCode (cprefix = "TOX_")]
	//public void VERSION_IS_ABI_COMPATIBLE(MAJOR, MINOR, PATCH);
	[CCode (cprefix = "TOX_")]
	public const int PUBLIC_KEY_SIZE;
	[CCode (cprefix = "TOX_")]
	public const int SECRET_KEY_SIZE;
	//[CCode (cprefix = "TOX_")]
	//public void ADDRESS_SIZE(PUBLIC_KEY_SIZE + sizeof(uint32) + sizeof(uint16));
	[CCode (cprefix = "TOX_")]
	public const int MAX_NAME_LENGTH;
	[CCode (cprefix = "TOX_")]
	public const int MAX_STATUS_MESSAGE_LENGTH;
	[CCode (cprefix = "TOX_")]
	public const int MAX_FRIEND_REQUEST_LENGTH;
	[CCode (cprefix = "TOX_")]
	public const int MAX_MESSAGE_LENGTH;
	[CCode (cprefix = "TOX_")]
	public const int MAX_CUSTOM_PACKET_SIZE;
	[CCode (cprefix = "TOX_")]
	public const int HASH_LENGTH;
	[CCode (cprefix = "TOX_")]
	public const int FILE_ID_LENGTH;
	[CCode (cprefix = "TOX_")]
	public const int MAX_FILENAME_LENGTH;

	[CCode (cname = "TOX_USER_STATUS", cprefix = "TOX_USER_STATUS_", has_type_id = false)]
	public enum UserStatus {
		NONE,
		AWAY,
		BUSY
	}

	[CCode (cname = "TOX_MESSAGE_TYPE", cprefix = "TOX_MESSAGE_TYPE_", has_type_id = false)]
	public enum MessageType {
		NORMAL,
		ACTION
	}

	[CCode (cname = "TOX_PROXY_TYPE", cprefix = "TOX_PROXY_TYPE_", has_type_id = false)]
	public enum ProxyType {
		NONE,
		HTTP,
		SOCKS5
	}

	[CCode (cname = "TOX_SAVEDATA_TYPE", cprefix = "TOX_SAVEDATA_TYPE_", has_type_id = false)]
	public enum SaveDataType {
		NONE,
		TOX_SAVE,
		SECRET_KEY
	}

	[CCode (cname = "TOX_ERR_OPTIONS_NEW", cprefix = "TOX_ERR_OPTIONS_NEW_", has_type_id = false)]
	public enum ErrNewOptions {
		OK,
		MALLOC
	}

	[CCode (cname = "TOX_ERR_NEW", cprefix = "TOX_ERR_NEW_", has_type_id = false)]
	public enum NewErr {
		OK,
		NULL,
		MALLOC,
		PORT_ALLOC,
		PROXY_BAD_TYPE,
		PROXY_BAD_HOST,
		PROXY_BAD_PORT,
		PROXY_NOT_FOUND,
		LOAD_ENCRYPTED,
		BAD_FORMAT
	}

	[CCode (cname = "TOX_ERR_BOOTSTRAP", cprefix = "TOX_ERR_BOOTSTRAP_", has_type_id = false)]
	public enum BootstrapErr{
		OK,
		NULL,
		BAD_HOST,
		BAD_PORT
	}

	[CCode (cname = "TOX_CONNECTION", cprefix = "TOX_CONNECTION_", has_type_id = false)]
	enum Connection{
		NONE,
		TCP,
		UDP
	}

/*	[CCode (cname = "void")]
	public class SelfConnectionStatus{
		[CCode (cname = "tox_self_connection_status_cb")]
	}*/

	[CCode (cname = "TOX_ERR_SET_INFO", cprefix = "TOX_ERR_SET_INFO_", has_type_id = false)]
	enum SetInfoErr{
		OK,
		NULL,
		TOO_LONG
	}

	[CCode (cname = "TOX_ERR_FRIEND_ADD", cprefix = "TOX_ERR_FRIEND_ADD_", has_type_id = false)]
	public enum FriendAddError {
		OK,
		NULL,
		TOO_LONG,
		NO_MESSAGE,
		OWN_KEY,
		ALREADY_SENT,
		BAD_CHECKSUM,
		SET_NEW_NOSPAM,
		MALLOC
	}

	[CCode (cname = "TOX_ERR_FRIEND_DELETE", cprefix = "TOX_ERR_FRIEND_DELETE_", has_type_id = false)]
	public enum FriendDeleteError{
		OK,
		NOT_FOUND
	}

	[CCode (cname = "TOX_ERR_FRIEND_BY_PUBLIC_KEY", cprefix = "TOX_ERR_FRIEND_BY_PUBLIC_KEY_", has_type_id = false)]
	enum FriendByPubkeyErr {
		OK,
		FRIEND_NOT_FOUND
	}

	[CCode (cname = "TOX_ERR_FRIEND_GET_LAST_ONLINE", cprefix = "TOX_ERR_FRIEND_GET_LAST_ONLINE_", has_type_id = false)]
	enum FriendGetPubkeyErr {
		OK,
		FRIEND_NOT_FOUND
	}

	[CCode (cname = "TOX_ERR_FRIEND_QUERY", cprefix = "TOX_ERR_FRIEND_QUERY_", has_type_id = false)]
	enum FriendQueryErr {
		OK,
		NULL,
		FRIEND_NOT_FOUND
	}

/*
	[CCode (cname = "void")]
	public class FriendNameCb{
		[CCode cname="tox_friend_name_cb"]
	}

	[CCode (cname = "void")]
	public class FriendStatusMessageCb{
		[CCode cname="tox_friend_status_message_cb"]
	}

	[CCode (cname = "void")]
	public class FriendStatusCb{
		[CCode cname="tox_friend_status_cb"]
	}

	[CCode (cname = "void")]
	public class FriendConnectionStatusCb{
		[CCode cname="tox_friend_connection_status_cb"]
	}

	[CCode (cname = "void")]
	public class FriendTypingCb{
		[CCode cname="tox_friend_typing_cb"]
	}
*/
	[CCode (cname = "TOX_ERR_SET_TYPING", cprefix = "TOX_ERR_SET_TYPING_", has_type_id = false)]
	enum SetTypingErr {
		OK,
		NULL,
		FRIEND_NOT_FOUND
	}

	[CCode (cname = "TOX_ERR_FRIEND_SEND_MESSAGE", cprefix = "TOX_ERR_FRIEND_SEND_MESSAGE_", has_type_id = false)]
	enum SendMessageErr {
		OK,
		NULL,
		FRIEND_NOT_FOUND,
		FRIEND_NOT_CONNECTED,
		SENDQ,
		TOO_LONG,
		EMPTY
	}

/*	[CCode (cname = "void")]
	public class FriendReadReceiptCb{
		[CCode cname="tox_friend_read_reciept_cb"]
	}
	[CCode (cname = "void")]
	public class FriendRequestCb{
		[CCode cname="tox_friend_request_cb"]
	}
	[CCode (cname = "void")]
	public class FriendMessageCb{
		[CCode cname="tox_friend_message_cb"]
	}
*/
	[CCode (cname = "TOX_FILE_KIND", cprefix = "TOX_FILE_KIND_", has_type_id = false)]
	enum FileKind {
		DATA,
		AVATAR
	}

	[CCode (cname = "TOX_FILE_CONTROL", cprefix = "TOX_FILE_CONTROL_", has_type_id = false)]
	enum FileControl {
		RESUME,
		PAUSE,
		CANCEL
	}

	[CCode (cname = "TOX_ERR_FILE_CONTROL", cprefix = "TOX_ERR_FILE_CONTROL_", has_type_id = false)]
	enum FileControlErr {
		OK,
		FRIEND_NOT_FOUND,
		FRIEND_NOT_CONNECTED,
		NOT_FOUND,
		NOT_PAUSED,
		DENIED,
		ALREADY_PAUSED,
		SENDQ
	}

/*	[CCode (cname = "void")]
	public class FileRecieveControlCb{
		[CCode cname="tox_file_recv_control_cb"]
	}
*/
	[CCode (cname = "TOX_ERR_FILE_SEEK", cprefix = "TOX_ERR_FILE_SEEK_", has_type_id = false)]
	enum FileSeekErr {
		OK,
		FRIEND_NOT_FOUND,
		FRIEND_NOT_CONNECTED,
		NOT_FOUND,
		DENIED,
		INVALID_POSITION,
		SENDQ
	}

	[CCode (cname = "TOX_ERR_FILE_GET", cprefix = "TOX_ERR_FILE_GET_", has_type_id = false)]
	enum FileGetErr {
		OK,
		NULL,
		FRIEND_NOT_FOUND,
		NOT_FOUND
	}

	[CCode (cname = "TOX_ERR_FILE_SEND", cprefix = "TOX_ERR_FILE_SEND_", has_type_id = false)]
	enum FileSendErr {
		OK,
		NULL,
		FRIEND_NOT_FOUND,
		FRIEND_NOT_CONNECTED,
		NAME_TOO_LONG,
		TOO_MANY
	}

	[CCode (cname = "TOX_ERR_FILE_SEND_CHUNK", cprefix = "TOX_ERR_FILE_SEND_CHUNK_", has_type_id = false)]
	enum SendChunkErr {
		OK,
		NULL,
		FRIEND_NOT_FOUND,
		FRIEND_NOT_CONNECTED,
		NOT_FOUND,
		NOT_TRANSFERRING,
		INVALID_LENGTH,
		SENDQ,
		WRONG_POSITION
	}

/*	[CCode (cname = "void")]
	public class FileChunkRequestCb{
		[CCode cname="tox_file_chunch_request_cb"]
	}

	[CCode (cname = "void")]
	public class FileRecieveCb{
		[CCode cname="tox_file_recieve_cb"]
	}

	[CCode (cname = "void")]
	public class FileRecieveChunkCb{
		[CCode cname="tox_file_recieve_chunk_cb"]
	}
*/

	[CCode (cname = "TOX_ERR_FRIEND_CUSTOM_PACKET", cprefix = "TOX_ERR_FRIEND_CUSTOM_PACKET_", has_type_id = false)]
	enum CustomPacketErr {
		OK,
		NULL,
		FRIEND_NOT_FOUND,
		FRIEND_NOT_CONNECTED,
		INVALID,
		EMPTY,
		TOO_LONG,
		SENDQ
	}

/*	[CCode (cname = "void")]
	public class FriendLossyPacketCb{
		[CCode cname="tox_friend_lossy_packet_cb"]
	}
	[CCode (cname = "void")]
	public class FriendLosslessPacketCb{
		[CCode cname="tox_friend_lossless_packet_cb"]
	}
*/

	[CCode (cname = "gint32", cprefix = "TOX_ERR_GET_PORT_", has_type_id = false)]
	enum GetPortErr {
		OK,
		NOT_BOUND
	}

	[CCode (cname = "TOX_GROUPCHAT_TYPE", cprefix = "TOX_GROUPCHAT_TYPE_", has_type_id = false)]
	enum GroupchatType {
		TEXT,
		AV
	}

	[CCode (cname = "TOX_CHAT_CHANGE", cprefix = "TOX_CHAT_CHANGE_", has_type_id = false)]
	enum ChatChange {
		PEER_ADD,
		PEER_DEL,
		CHANGE_PEER_NAME
	}

	[CCode (cname = "Tox_Options",  destroy_function = "tox_options_free", has_type_id = false)]
	public struct Options {
		[CCode (cname = "tox_options_new")]
		//public Options(ToxOptionsErr? error)
		/*
		*	The type of UDP socket created depends on ipv6enabled:
		*	If set to 0 (zero), creates an IPv4 socket which subsequently only allows
		*		IPv4 communication
		*	If set to anything else (default), creates an IPv6 socket which allows both IPv4 AND
		*		IPv6 communication
		*/
		uint8 ipv6enabled;
		 /*
		 * Set to 1 to disable udp support. (default: 0)
		 * This will force Tox to use TCP only which may slow things down.
		 * Disabling udp support is necessary when using anonymous proxies or Tor.
		 */
		uint8 udp_disabled;
		/* Enable proxy support. (only basic TCP socks5 proxy currently supported.) (default: TOX_PROXY_NONE (disabled))*/
		ProxyType proxy_type;
		/* Proxy ip or domain in NULL terminated string format. */
		char proxy_host[256];
		/* Proxy port: in host byte order. */
		uint16 proxy_port;
		uint16 start_port;
		uint16 end_port;
		uint16 tcp_port;
		SaveDataType savedata_type;
		const uint8 savedata_data;
		size_t savedata_length;
	}

	[CCode (cname = "Tox", free_function = "tox_kill", cprefix = "tox_", has_type_id = false)]
	[Compact]
	public class Tox {
		[CCode (cname = "tox_new")]
		public Tox (Options? options = null);

		size_t get_savedata_size (Tox tox);
		void get_savedata (Tox tox, [CCode(array_length=false)] uint8[] savedata);

		public bool bootstrap (string address, int port, [CCode (array_length=false)] uint8[] public_key, BootstrapErr? error);
		public bool add_tcp_relay (Tox tox, char address, [CCode (array_length=false)] uint16[] port, [CCode (array_length=false)] uint8[] public_key, BootstrapErr error);

		Connection self_get_connection_status (Tox tox);
		void self_get_connection_status_cb (Tox tox, Connection connection_status, [CCode(array_length_type="guint16")] uint8[] user_data);
		//void callback_self_connection_status(Tox tox, self_connection_status_cb callback, [CCode(array_length_type="guint16")] uint8[] user_data);

		[CCode (cname = "tox_iterate")]
		public void wait ();

		public void self_get_public_key(Tox tox, [CCode (array_length=false)] uint8[] public_key);
	}
}
