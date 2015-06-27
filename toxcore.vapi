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

[CCode (cheader_filename = "tox/tox.h", cprefix = "tox_")]
namespace Tox {
	[CCode (cprefix = "TOX_")]
	public const int DEFINED;

	[CCode (cprefix = "TOX_")]
	public const int VERSION_MAJOR;
	[CCode (cprefix = "TOX_")]
	public const int VERSION_MINOR;
	[CCode (cprefix = "TOX_")]
	public const int VERSION_PATCH;
/*
	[CCode (cprefix = "TOX_")]
	public const int VERSION_IS_API_COMPATIBLE;
	[CCode (cprefix = "TOX_")]
	public const int TOX_VERSION_REQUIRE;
	[CCode (cprefix = "TOX_")]
	public const int TOX_VERSION_IS_ABI_COMPATIBLE;*/
	[CCode (cprefix = "TOX_")]
	public const int PUBLIC_KEY_SIZE;
	[CCode (cprefix = "TOX_")]
	public const int SECRET_KEY_SIZE;
/*	[CCode (cprefix = "TOX_")]
	public const int ADDRESS_SIZE;*/
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
		BUSY,
		INVALID
	}

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
	enum BootstrapErr{
		OK,
		NULL,
		BAD_HOST,
		BAD_PORT
	}

	[CCode (cname = "TOX_CONNECTION", cprefix = "TOX_CONNECTION_", has_type_id = false)]
	enum ConnectionErr{
		NONE,
		TCP,
		UDP
	}

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

	[CCode (cname = "TOX_ERR_FRIEND_GET_LAST_ONLINE", cprefix = "TOX_ERR_FRIEND_GET_LAST_ONLINE_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_FRIEND_QUERY", cprefix = "TOX_ERR_FRIEND_QUERY_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_SET_TYPING", cprefix = "TOX_ERR_SET_TYPING_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_FRIEND_SEND_MESSAGE", cprefix = "TOX_ERR_FRIEND_SEND_MESSAGE_", has_type_id = false)]

	[CCode (cname = "TOX_FILE_KIND", cprefix = "TOX_FILE_KIND_", has_type_id = false)]

	[CCode (cname = "TOX_FILE_CONTROL", cprefix = "TOX_FILE_CONTROL_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_FILE_CONTROL", cprefix = "TOX_ERR_FILE_CONTROL_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_FILE_SEEK", cprefix = "TOX_ERR_FILE_SEEK_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_FILE_GET", cprefix = "TOX_ERR_FILE_GET_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_FILE_SEND", cprefix = "TOX_ERR_FILE_SEND_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_FILE_SEND_CHUNK", cprefix = "TOX_ERR_FILE_SEND_CHUNK_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_FRIEND_CUSTOM_PACKET", cprefix = "TOX_ERR_FRIEND_CUSTOM_PACKET_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_GET_PORT", cprefix = "TOX_ERR_GET_PORT_", has_type_id = false)]

	[CCode (cname = "TOX_GROUPCHAT_TYPE", cprefix = "TOX_GROUPCHAT_TYPE_", has_type_id = false)]
	[CCode (cname = "TOX_CHAT_CHANGE", cprefix = "TOX_CHAT_CHANGE_", has_type_id = false)]

	[CCode (cname = "Tox", free_function = "tox_kill", cprefix = "tox_", has_type_id = false)]
	[Compact]
	public class Tox {
	}
}