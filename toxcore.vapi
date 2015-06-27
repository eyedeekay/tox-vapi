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

	[CCode (cname = "TOX_MESSAGE_TYPE", cprefix = "TOX_MESSAGE_TYPE_", has_type_id = false)]	

	[CCode (cname = "TOX_PROXY_TYPE", cprefix = "TOX_PROXY_TYPE_", has_type_id = false)]

	[CCode (cname = "TOX_SAVEDATA_TYPE", cprefix = "TOX_SAVEDATA_TYPE_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_OPTIONS_NEW", cprefix = "TOX_ERR_OPTIONS_NEW_", has_type_id = false)]

	[CCode (cname = "TOX_ERR_NEW", cprefix = "TOX_ERR_NEW_", has_type_id = false)]

	[CCode (cname = "", cprefix = "", has_type_id = false)]

	[CCode (cname = "TOX_ERR_FRIEND_ADD", cprefix = "TOX_ERR_FRIEND_ADD_", has_type_id = false)]
	public enum FriendAddError {
		TOOLONG,
		NOMESSAGE,
		OWNKEY,
		ALREADYSENT,
		UNKNOWN,
		BADCHECKSUM,
		SETNEWNOSPAM,
		NOMEM
	}

	[CCode (cname = "TOX_ERR_FRIEND_DELETE", cprefix = "TOX_ERR_FRIEND_DELETE_", has_type_id = false)]
	public enum FriendDeleteError{
		OK,
		NOTFOUND
	}

	[CCode (cname = "", cprefix = "", has_type_id = false)]

	[CCode (cname = "Tox_Options",  destroy_function = "", has_type_id = false)]
	public struct Options {
	}

	[CCode (cname = "Tox", free_function = "tox_kill", cprefix = "tox_", has_type_id = false)]
	[Compact]
	public class Tox {
	}
}