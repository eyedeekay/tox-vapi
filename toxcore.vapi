/**
*       COPYRIGHT (c) 2015 SkyzohKey
*
*       DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
*               Version 2, December 2004
*
*       Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
*
*       Everyone is permitted to copy and distribute verbatim or modified
*       copies of this license document, and changing it is allowed as long
*       as the name is changed.
*
*       DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
*       TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
*
*       0. You just DO WHAT THE FUCK YOU WANT TO.
*/
using GLib;

[CCode (cheader_filename = "tox/tox.h", cprefix = "Tox_")]
namespace Tox {
// Function from Desiderantes: https://hec.su/bFsT
    public string arr2str (uint8[] array) {
        uint8[] name = new uint8[array.length + 1];
        GLib.Memory.copy (name, array, sizeof(uint8)* name.length);
        name[array.length] = '\0';
        return ((string) name).to_string ();
    }

    /*******************************************************************************
     *
     * :: API version
     *
     ******************************************************************************/
    [CCode (cprefix = "TOX_VERSION_")]
    namespace Version {
        /**
         * The major version number. Incremented when the API or ABI changes in an
         * incompatible way.
         */
        public const uint32 MAJOR;

        /**
         * The minor version number. Incremented when functionality is added without
         * breaking the API or ABI. Set to 0 when the major version number is
         * incremented.
         */
        public const uint32 MINOR;

        /**
         * The patch or revision number. Incremented when bugfixes are applied without
         * changing any functionality or API or ABI.
         */
        public const uint32 PATCH;

        /**
         * A macro to check at preprocessing time whether the client code is compatible
         * with the installed version of
         */
        [CCode (cname="TOX_VERSION_IS_API_COMPATIBLE")]
        public static bool is_api_compatible (uint32 major, uint32 minor, uint32 patch);

        /**
         * A macro to make compilation fail if the client code is not compatible with
         * the installed version of
         */
        [CCode (cname="TOX_VERSION_REQUIRE")]
        public char require_version (uint32 major, uint32 minor, uint32 patch);

        /**
         * Return the major version number of the library. Can be used to display the
         * Tox library version or to check whether the client is compatible with the
         * dynamically linked version of
         */
        [CCode (cname="tox_version_major")]
        public uint32 lib_major ();

        /**
         * Return the minor version number of the library.
         */
        [CCode (cname="tox_version_minor")]
        public uint32 lib_minor ();

        /**
         * Return the patch number of the library.
         */
        [CCode (cname="tox_version_patch")]
        public uint32 lib_patch ();

        /**
         * Return whether the compiled library version is compatible with the passed
         * version numbers.
         */
        [CCode (cname="tox_version_is_compatible")]
        public bool is_compatible (uint32 major, uint32 minor, uint32 patch);

        /**
         * A convenience macro to call tox_version_is_compatible with the currently
         * compiling API version.
         */
        [CCode (cname="TOX_VERSION_IS_ABI_COMPATIBLE")]
        public bool is_abi_compatible ();
    }

    /*******************************************************************************
     *
     * :: Numeric constants
     *
     ******************************************************************************/

    /**
     * The size of a Tox Public Key in bytes.
     */
    [CCode (cprefix="TOX_")]
    public int PUBLIC_KEY_SIZE;

    /**
     * The size of a Tox Secret Key in bytes.
     */
    [CCode (cprefix="TOX_")]
    public int SECRET_KEY_SIZE;

    /**
     * The size of a Tox address in bytes. Tox addresses are in the format
     * [Public Key (TOX_PUBLIC_KEY_SIZE bytes)][nospam (4 bytes)][checksum (2 bytes)].
     *
     * The checksum is computed over the Public Key and the nospam value. The first
     * byte is an XOR of all the even bytes (0, 2, 4, ...), the second byte is an
     * XOR of all the odd bytes (1, 3, 5, ...) of the Public Key and nospam.
     */
    [CCode (cprefix="TOX_")]
    public int ADDRESS_SIZE;

    /**
     * Maximum length of a nickname in bytes.
     */
    [CCode (cprefix="TOX_")]
    public int MAX_NAME_LENGTH;

    /**
     * Maximum length of a status message in bytes.
     */
    [CCode (cprefix="TOX_")]
    public int MAX_STATUS_MESSAGE_LENGTH;

    /**
     * Maximum length of a friend request message in bytes.
     */
    [CCode (cprefix="TOX_")]
    public int MAX_FRIEND_REQUEST_LENGTH;

    /**
     * Maximum length of a single message after which it should be split.
     */
    [CCode (cprefix="TOX_")]
    public int MAX_MESSAGE_LENGTH;

    /**
     * Maximum size of custom packets.
     * TODO: should be LENGTH?
     */
    [CCode (cprefix="TOX_")]
    public int MAX_CUSTOM_PACKET_SIZE;

    /**
     * The number of bytes in a hash generated by tox_hash.
     */
    [CCode (cprefix="TOX_")]
    public int HASH_LENGTH;

    /**
     * The number of bytes in a file id.
     */
    [CCode (cprefix="TOX_")]
    public int FILE_ID_LENGTH;

    /**
     * Maximum file name length for file transfers.
     */
    [CCode (cprefix="TOX_")]
    public int MAX_FILENAME_LENGTH;

    /*******************************************************************************
     *
     * :: Global enumerations
     *
     ******************************************************************************/

    /**
     * Represents the possible statuses a client can have.
     */
    [CCode (cname="TOX_USER_STATUS", cprefix="TOX_USER_STATUS_", has_type_id=false)]
    public enum UserStatus {
        /**
        * User is online and available.
        */
        NONE,

        /**
        * User is away. Clients can set this e.g. after a user defined
        * inactivity time.
        */
        AWAY,

        /**
        * User is busy. Signals to other clients that this client does not
        * currently wish to communicate.
        */
        BUSY
    }

    /**
     * Protocols that can be used to connect to the network or friends.
     */
    [CCode (cname="TOX_CONNECTION", cprefix="TOX_CONNECTION", has_type_id=false)]
    public enum ConnectionStatus {
        /**
         * There is no connection. This instance, or the friend the state change is
         * about, is now offline.
         */
        NONE,

        /**
         * A TCP connection has been established. For the own instance, this means it
         * is connected through a TCP relay, only. For a friend, this means that the
         * connection to that particular friend goes through a TCP relay.
         */
        TCP,

        /**
         * A UDP connection has been established. For the own instance, this means it
         * is able to send UDP packets to DHT nodes, but may still be connected to
         * a TCP relay. For a friend, this means that the connection to that
         * particular friend was built using direct UDP packets.
         */
        UDP
    }

    [CCode (cname="TOX_FILE_CONTROL", cprefix="TOX_FILE_CONTROL_", has_type_id=false)]
    public enum FileControlStatus {
        RESUME,
        PAUSE,
        CANCEL,
    }
    [CCode (cname="TOX_FILE_KIND", cprefix="TOX_FILE_KIND_", has_type_id=false)]
    public enum FileKind {
        /**
         * Arbitrary file data. Clients can choose to handle it based on the file name
         * or magic or any other way they choose.
         */
        DATA,

        /**
         * Avatar file_id. This consists of tox_hash(image).
         * Avatar data. This consists of the image data.
         *
         * Avatars can be sent at any time the client wishes. Generally, a client will
         * send the avatar to a friend when that friend comes online, and to all
         * friends when the avatar changed. A client can save some traffic by
         * remembering which friend received the updated avatar already and only send
         * it if the friend has an out of date avatar.
         *
         * Clients who receive avatar send requests can reject it (by sending
         * TOX_FILE_CONTROL_CANCEL before any other controls), or accept it (by
         * sending TOX_FILE_CONTROL_RESUME). The file_id of length TOX_HASH_LENGTH bytes
         * (same length as TOX_FILE_ID_LENGTH) will contain the hash. A client can compare
         * this hash with a saved hash and send TOX_FILE_CONTROL_CANCEL to terminate the avatar
         * transfer if it matches.
         *
         * When file_size is set to 0 in the transfer request it means that the client
         * has no avatar.
         */
        AVATAR
    }

    /**
     * Represents message types for tox_friend_send_message and group chat
     * messages.
     */
    [CCode (cname="TOX_MESSAGE_TYPE", cprefix="TOX_MESSAGE_TYPE_", has_type_id=false)]
    public enum MessageType {
        /**
        * Normal text message. Similar to PRIVMSG on IRC.
        */
        NORMAL,

        /**
        * A message describing an user action. This is similar to /me (CTCP ACTION)
        * on IRC.
        */
        ACTION
    }

    /*******************************************************************************
     *
     * :: Startup options
     *
     ******************************************************************************/

    /**
    * Type of proxy used to connect to TCP relays.
    */
    [CCode (cname="TOX_PROXY_TYPE", cprefix="TOX_PROXY_TYPE_", has_type_id=false)]
    public enum ProxyType {
        /**
        * Don't use a proxy.
        */
        NONE,

        /**
        * HTTP proxy using CONNECT.
        */
        HTTP,

        /**
        * SOCKS proxy for simple socket pipes.
        */
        SOCKS5
    }

    /**
     * Type of savedata to create the Tox instance from.
     */
    [CCode (cname="TOX_SAVEDATA_TYPE", cprefix="TOX_SAVEDATA_TYPE_", has_type_id=false)]
    public enum SaveDataType {
        /**
        * No savedata.
        */
        NONE,

        /**
        * Savedata is one that was obtained from tox_get_savedata
        */
        TOX_SAVE,

        /**
        * Savedata is a secret key of length TOX_SECRET_KEY_SIZE
        */
        SECRET_KEY
    }

    /*******************************************************************************
     *
     * :: Private errors enums
     *
     ******************************************************************************/

    [CCode (cname="TOX_ERR_NEW", cprefix = "TOX_ERR_NEW_")]
    public enum TOX_ERR_NEW {
        /**
         * The function returned successfully.
         */
        OK,

        /**
         * One of the arguments to the function was NULL when it was not expected.
         */
        NULL,

        /**
         * The function was unable to allocate enough memory to store the internal
         * structures for the Tox object.
         */
        MALLOC,

        /**
         * The function was unable to bind to a port. This may mean that all ports
         * have already been bound, e.g. by other Tox instances, or it may mean
         * a permission error. You may be able to gather more information from errno.
         */
        PORT_ALLOC,

        /**
         * proxy_type was invalid.
         */
        PROXY_BAD_TYPE,

        /**
         * proxy_type was valid but the proxy_host passed had an invalid format
         * or was NULL.
         */
        PROXY_BAD_HOST,

        /**
         * proxy_type was valid, but the proxy_port was invalid.
         */
        PROXY_BAD_PORT,

        /**
         * The proxy address passed could not be resolved.
         */
        PROXY_NOT_FOUND,

        /**
         * The byte array to be loaded contained an encrypted save.
         */
        LOAD_ENCRYPTED,

        /**
         * The data format was invalid. This can happen when loading data that was
         * saved by an older version of Tox, or when the data has been corrupted.
         * When loading from badly formatted data, some data may have been loaded,
         * and the rest is discarded. Passing an invalid length parameter also
         * causes this error.
         */
        LOAD_BAD_FORMAT,
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_OPTIONS_NEW {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * One of the arguments to the function was NULL when it was not expected.
         */
        NULL,

        /**
         * The function was unable to allocate enough memory to store the internal
         * structures for the Tox object.
         */
        MALLOC,

        /**
         * The function was unable to bind to a port. This may mean that all ports
         * have already been bound, e.g. by other Tox instances, or it may mean
         * a permission error. You may be able to gather more information from errno.
         */
        PORT_ALLOC,

        /**
         * proxy_type was invalid.
         */
        PROXY_BAD_TYPE,

        /**
         * proxy_type was valid but the proxy_host passed had an invalid format
         * or was NULL.
         */
        PROXY_BAD_HOST,

        /**
         * proxy_type was valid, but the proxy_port was invalid.
         */
        PROXY_BAD_PORT,

        /**
         * The proxy address passed could not be resolved.
         */
        PROXY_NOT_FOUND,

        /**
         * The byte array to be loaded contained an encrypted save.
         */
        LOAD_ENCRYPTED,

        /**
         * The data format was invalid. This can happen when loading data that was
         * saved by an older version of Tox, or when the data has been corrupted.
         * When loading from badly formatted data, some data may have been loaded,
         * and the rest is discarded. Passing an invalid length parameter also
         * causes this error.
         */
        LOAD_BAD_FORMAT
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_BOOTSTRAP {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * One of the arguments to the function was NULL when it was not expected.
         */
        NULL,

        /**
         * The address could not be resolved to an IP address, or the IP address
         * passed was invalid.
         */
        BAD_HOST,

        /**
         * The port passed was invalid. The valid port range is (1, 65535).
         */
        BAD_PORT
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_SET_INFO {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * One of the arguments to the function was NULL when it was not expected.
         */
        NULL,

        /**
         * Information length exceeded maximum permissible size.
         */
        TOO_LONG
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FRIEND_ADD {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * One of the arguments to the function was NULL when it was not expected.
         */
        NULL,

        /**
         * The length of the friend request message exceeded
         * TOX_MAX_FRIEND_REQUEST_LENGTH.
         */
        TOO_LONG,

        /**
         * The friend request message was empty. This, and the TOO_LONG code will
         * never be returned from tox_friend_add_norequest.
         */
        NO_MESSAGE,

        /**
         * The friend address belongs to the sending client.
         */
        OWN_KEY,

        /**
         * A friend request has already been sent, or the address belongs to a friend
         * that is already on the friend list.
         */
        ALREADY_SENT,

        /**
         * The friend address checksum failed.
         */
        BAD_CHECKSUM,

        /**
         * The friend was already there, but the nospam value was different.
         */
        SET_NEW_NOSPAM,

        /**
         * A memory allocation failed when trying to increase the friend list size.
         */
        MALLOC
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FRIEND_DELETE {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * There was no friend with the given friend number. No friends were deleted.
         */
        FRIEND_NOT_FOUND
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FRIEND_BY_PUBLIC_KEY {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * One of the arguments to the function was NULL when it was not expected.
         */
        NULL,

        /**
         * No friend with the given Public Key exists on the friend list.
         */
        NOT_FOUND
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FRIEND_GET_PUBLIC_KEY {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * No friend with the given number exists on the friend list.
         */
        FRIEND_NOT_FOUND
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FRIEND_GET_LAST_ONLINE {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * No friend with the given number exists on the friend list.
         */
        FRIEND_NOT_FOUND
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FRIEND_QUERY {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * The pointer parameter for storing the query result (name, message) was
         * NULL. Unlike the `_self_` variants of these functions, which have no effect
         * when a parameter is NULL, these functions return an error in that case.
         */
        NULL,

        /**
         * The friend_number did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        NOT_FOUND
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_SET_TYPING {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * The friend number did not designate a valid friend.
         */
        FRIEND_NOT_FOUND
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FRIEND_SEND_MESSAGE {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * One of the arguments to the function was NULL when it was not expected.
         */
        NULL,

        /**
         * The friend number did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        /**
         * This client is currently not connected to the friend.
         */
        FRIEND_NOT_CONNECTED,

        /**
         * An allocation error occurred while increasing the send queue size.
         */
        SENDQ,

        /**
         * Message length exceeded TOX_MAX_MESSAGE_LENGTH.
         */
        TOO_LONG,

        /**
         * Attempted to send a zero-length message.
         */
        EMPTY
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FILE_CONTROL {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * The friend_number passed did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        /**
         * This client is currently not connected to the friend.
         */
        FRIEND_NOT_CONNECTED,

        /**
         * No file transfer with the given file number was found for the given friend.
         */
        NOT_FOUND,

        /**
         * A RESUME control was sent, but the file transfer is running normally.
         */
        NOT_PAUSED,

        /**
         * A RESUME control was sent, but the file transfer was paused by the other
         * party. Only the party that paused the transfer can resume it.
         */
        DENIED,

        /**
         * A PAUSE control was sent, but the file transfer was already paused.
         */
        ALREADY_PAUSED,

        /**
         * Packet queue is full.
         */
        SENDQ
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FILE_SEEK {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * The friend_number passed did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        /**
         * This client is currently not connected to the friend.
         */
        FRIEND_NOT_CONNECTED,

        /**
         * No file transfer with the given file number was found for the given friend.
         */
        NOT_FOUND,

        /**
         * File was not in a state where it could be seeked.
         */
        DENIED,

        /**
         * Seek position was invalid
         */
        INVALID_POSITION,

        /**
         * Packet queue is full.
         */
        SENDQ
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FILE_GET {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * One of the arguments to the function was NULL when it was not expected.
         */
        NULL,

        /**
         * The friend_number passed did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        /**
         * No file transfer with the given file number was found for the given friend.
         */
        NOT_FOUND
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FILE_SEND {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * One of the arguments to the function was NULL when it was not expected.
         */
        NULL,

        /**
         * The friend_number passed did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        /**
         * This client is currently not connected to the friend.
         */
        FRIEND_NOT_CONNECTED,

        /**
         * Filename length exceeded TOX_MAX_FILENAME_LENGTH bytes.
         */
        NAME_TOO_LONG,

        /**
         * Too many ongoing transfers. The maximum number of concurrent file transfers
         * is 256 per friend per direction (sending and receiving).
         */
        TOO_MANY
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FILE_SEND_CHUNK {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * The length parameter was non-zero, but data was NULL.
         */
        NULL,

        /**
         * The friend_number passed did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        /**
         * This client is currently not connected to the friend.
         */
        FRIEND_NOT_CONNECTED,

        /**
         * No file transfer with the given file number was found for the given friend.
         */
        NOT_FOUND,

        /**
         * File transfer was found but isn't in a transferring state: (paused, done,
         * broken, etc...) (happens only when not called from the request chunk callback).
         */
        NOT_TRANSFERRING,

        /**
         * Attempted to send more or less data than requested. The requested data size is
         * adjusted according to maximum transmission unit and the expected end of
         * the file. Trying to send less or more than requested will return this error.
         */
        INVALID_LENGTH,

        /**
         * Packet queue is full.
         */
        SENDQ,

        /**
         * Position parameter was wrong.
         */
        WRONG_POSITION
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_FRIEND_CUSTOM_PACKET {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * One of the arguments to the function was NULL when it was not expected.
         */
        NULL,

        /**
         * The friend number did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        /**
         * This client is currently not connected to the friend.
         */
        FRIEND_NOT_CONNECTED,

        /**
         * The first byte of data was not in the specified range for the packet type.
         * This range is 200-254 for lossy, and 160-191 for lossless packets.
         */
        INVALID,

        /**
         * Attempted to send an empty packet.
         */
        EMPTY,

        /**
         * Packet data length exceeded TOX_MAX_CUSTOM_PACKET_SIZE.
         */
        TOO_LONG,

        /**
         * Packet queue is full.
         */
        SENDQ
    }

    [CCode (cprefix="")]
    private enum TOX_ERR_GET_PORT {
        /**
        * The function returned successfully.
        */
        OK,

        /**
         * The instance was not bound to any port.
         */
        NOT_BOUND
    }

    /*******************************************************************************
     *
     * :: Public errors (using Vala domainerror's)
     * :: Code taken from Desiderantes libvapi:
     * :: https://github.com/desiderantes/venom/blob/master/src/vapi/libvapi#L833
     *
     ******************************************************************************/

    public errordomain OptionError {
        NOMEM
    }

    public errordomain ConstructError {
        /**
         * The function was unable to bind to a port. This may mean that all ports
         * have already been bound, e.g. by other Tox instances, or it may mean
         * a permission error. You may be able to gather more information from errno.
         */
        BAD_PORT_ALLOC,

        /**
         * proxy_type was valid but the proxy_host passed had an invalid format
         * or was NULL.
         */
        BAD_HOST,

        /**
         * proxy_type was valid, but the proxy_port was invalid.
         */
        PORT_UNAVAILABLE,

        /**
         * The proxy address passed could not be resolved.
         */
        PROXY_NOT_FOUND,

        /**
         * The byte array to be loaded contained an encrypted save.
         */
        ENCRYPTED_DATA,

        /**
         * The data format was invalid. This can happen when loading data that was
         * saved by an older version of Tox, or when the data has been corrupted.
         * When loading from badly formatted data, some data may have been loaded,
         * and the rest is discarded. Passing an invalid length parameter also
         * causes this error.
         */
        MALFORMED_DATA,

        UNKNOWN,
    }

    public errordomain BootstrapError {
        BAD_DATA,
        BAD_HOST,
        BAD_PORT
    }

    public errordomain FriendAddError {
        TOOLONG,
        NOMESSAGE,
        OWNKEY,
        ALREADYSENT,
        UNKNOWN,
        BADCHECKSUM,
        SETNEWNOSPAM,
        NOMEM
    }

    public errordomain FriendGetError {
        NOT_FOUND,
        UNKNOWN
    }

    public errordomain SendMessageError {
        /**
         * The friend number did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        /**
         * This client is currently not connected to the friend.
         */
        FRIEND_NOT_CONNECTED,

        /**
         * An allocation error occurred while increasing the send queue size.
         */
        SENDQ,
    }

    public errordomain FileControlError {
        /**
         * The friend_number passed did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        /**
         * This client is currently not connected to the friend.
         */
        FRIEND_NOT_CONNECTED,

        /**
         * No file transfer with the given file number was found for the given friend.
         */
        NOT_FOUND,

        /**
         * A RESUME control was sent, but the file transfer is running normally.
         */
        NOT_PAUSED,

        /**
         * A RESUME control was sent, but the file transfer was paused by the other
         * party. Only the party that paused the transfer can resume it.
         */
        DENIED,

        /**
         * A PAUSE control was sent, but the file transfer was already paused.
         */
        ALREADY_PAUSED,

        /**
         * Packet queue is full.
         */
        SENDQ,
    }

    public errordomain FileSeekError {
        /**
         * The friend_number passed did not designate a valid friend.
         */
        FRIEND_NOT_FOUND,

        /**
         * This client is currently not connected to the friend.
         */
        FRIEND_NOT_CONNECTED,

        /**
         * No file transfer with the given file number was found for the given friend.
         */
        NOT_FOUND,

        /**
         * File was not in a state where it could be seeked.
         */
        DENIED,

        /**
         * Seek position was invalid
         */
        INVALID_POSITION,

        /**
         * Packet queue is full.
         */
        SENDQ,
    }

    public errordomain FileGetError {
        /**
        * The friend_number passed did not designate a valid friend.
        */
        FRIEND_NOT_FOUND,

        /**
         * No file transfer with the given file number was found for the given friend.
         */
        NOT_FOUND,
    }

    public errordomain FileSendError {
        FRIEND_NOT_FOUND,
        FRIEND_NOT_CONNECTED,
        TOO_MANY,
    }

    public errordomain FileSendChunkError {
        FRIEND_NOT_FOUND,
        FRIEND_NOT_CONNECTED,
        NOT_FOUND,
        NOT_TRANSFERRING,
        INVALID_LENGTH,
        SENDQ,
        WRONG_POSITION,
    }

    public errordomain CustomPacketError {
        /**
             * The friend number did not designate a valid friend.
             */
        FRIEND_NOT_FOUND,
        /**
         * This client is currently not connected to the friend.
         */
        FRIEND_NOT_CONNECTED,
        /**
         * The first byte of data was not in the specified range for the packet type.
         * This range is 200-254 for lossy, and 160-191 for lossless packets.
         */
        INVALID,
        /**
         * Packet data length exceeded TOX_MAX_CUSTOM_PACKET_SIZE.
         */
        TOO_LONG,
        /**
         * Packet queue is full.
         */
        SENDQ,
    }

    /*******************************************************************************
     *
     * :: Options
     *
     ******************************************************************************/

    /**
     * This class (struct in h) contains all the startup options for  You can either allocate
     * this object yourself, and pass it to tox_options_default, or call
     * tox_options_new to get a new default options object.
     */
    [CCode (cname = "Tox_Options", destroy_function = "tox_options_free", has_type_id = false)]
    [Compact]
    public class Options {
        /**
        * The type of socket to create.
        *
        * If this is set to false, an IPv4 socket is created, which subsequently
        * only allows IPv4 communication.
        * If it is set to true, an IPv6 socket is created, allowing both IPv4 and
        * IPv6 communication.
        */
        public bool ipv6_enabled;

        /**
        * Enable the use of UDP communication when available.
        *
        * Setting this to false will force Tox to use TCP only. Communications will
        * need to be relayed through a TCP relay node, potentially slowing them down.
        * Disabling UDP support is necessary when using anonymous proxies or Tor.
        */
        public bool udp_enabled;

        /**
        * Pass communications through a proxy.
        */
        public ProxyType proxy_type;

        /**
        * The IP address or DNS name of the proxy to be used.
        *
        * If used, this must be non-NULL and be a valid DNS name. The name must not
        * exceed 255 characters, and be in a NUL-terminated C string format
        * (255 chars + 1 NUL byte).
        *
        * This member is ignored (it can be NULL) if proxy_type is TOX_PROXY_TYPE_NONE.
        */
        public string? proxy_host;

        /**
        * The port to use to connect to the proxy server.
        *
        * Ports must be in the range (1, 65535). The value is ignored if
        * proxy_type is TOX_PROXY_TYPE_NONE.
        */
        public uint16 proxy_port;

        /**
        * The start port of the inclusive port range to attempt to use.
        *
        * If both start_port and end_port are 0, the default port range will be
        * used: [33445, 33545].
        *
        * If either start_port or end_port is 0 while the other is non-zero, the
        * non-zero port will be the only port in the range.
        *
        * Having start_port > end_port will yield the same behavior as if start_port
        * and end_port were swapped.
        */
        public uint16 start_port;

        /**
        * The end port of the inclusive port range to attempt to use.
        */
        public uint16 end_port;

        /**
        * The port to use for the TCP server (relay). If 0, the TCP server is
        * disabled.
        *
        * Enabling it is not required for Tox to function properly.
        *
        * When enabled, your Tox instance can act as a TCP relay for other Tox
        * instance. This leads to increased traffic, thus when writing a client
        * it is recommended to enable TCP server only if the user has an option
        * to disable it.
        */
        public uint16 tcp_port;

        /**
        * The type of savedata to load from.
        */
        public SaveDataType savedata_type;

        /**
        * The savedata.
        */
        [CCode (array_length_cname = "savedata_length", array_length_type = "size_t")]
        public uint8[] savedata_data;

        /**
         * Initialises a Tox_Options object with the default options.
         *
         * The result of this function is independent of the original options. All
         * values will be overwritten, no values will be read (so it is permissible
         * to pass an uninitialised object).
         */
        public void restore_defaults ();

        /**
         * Allocates a new Tox_Options object and initialises it with the default
         * options.
         * Objects returned from this function will be freed by Vala using the tox_options_free
         * function.
         *
         * @return A new Tox_Options object with default options or NULL on failure.
         */
        private static Options? options_new (TOX_ERR_OPTIONS_NEW error);
        public static Options? create () throws OptionError {
            TOX_ERR_OPTIONS_NEW err;
            Options opts = options_new (err);

            if (err == TOX_ERR_OPTIONS_NEW.MALLOC) {
                throw new OptionError.NOMEM ("Unable to allocate memory for Options object.");
            }

            return opts;
        }
    }

    /*******************************************************************************
     *
     * :: Tox
     *
     ******************************************************************************/

    [CCode (cname="Tox", free_function="tox_kill", cprefix="tox_", has_type_id=false)]
    [Compact]
    public class Tox {

        //public Tox () {}

        /*******************************************************************************
         *
         * :: Internal client information (Tox address/id)
         *
         ******************************************************************************/

        /**
        * A 4 byte value to fight spam requests.
        */
        public uint32 nospam {
            [CCode (cname="tox_self_get_nospam")] get;
            [CCode (cname="tox_self_set_nospam")] set;
        }

        public UserStatus status {
            [CCode (cname="tox_self_get_status")] get;
            [CCode (cname="tox_self_set_status")] set;
        }

        /**
         * Writes the Tox friend address of the client to a byte array. The address is
         * not in human-readable format. If a client wants to display the address,
         * formatting is required.
         *
         * @param address A memory region of at least TOX_ADDRESS_SIZE bytes. If this
         *   parameter is NULL, this function has no effect.
         * @see TOX_ADDRESS_SIZE for the address format.
         */
        private void self_get_address ([CCode (array_length=false)] uint8[] address);
        public uint8[] get_address () {
            uint8[] address = new uint8[ADDRESS_SIZE];
            self_get_address (address);
            return address;
        }

        /**
         * Copy the Tox Public Key (long term) from the Tox object.
         *
         * @param public_key A memory region of at least TOX_PUBLIC_KEY_SIZE bytes. If
         *   this parameter is NULL, this function has no effect.
         */
        private void self_get_public_key ([CCode (array_length=false)] uint8[] public_key);
        public uint8[] get_public_key () {
            uint8[] pkey = new uint8[PUBLIC_KEY_SIZE];
            self_get_public_key (pkey);
            return pkey;
        }

        /**
         * Copy the Tox Secret Key from the Tox object.
         *
         * @param secret_key A memory region of at least TOX_SECRET_KEY_SIZE bytes. If
         *   this parameter is NULL, this function has no effect.
         */
        private void self_get_secret_key ([CCode (array_length=false)] uint8[] secret_key);
        public uint8[] get_secret_key () {
            uint8[] skey = new uint8[SECRET_KEY_SIZE];
            self_get_secret_key (skey);
            return skey;
        }

        /*******************************************************************************
         *
         * :: User-visible client information (nickname/status)
         *
         ******************************************************************************/

        /**
        * Set the nickname for the Tox client.
        *
        * Nickname length cannot exceed TOX_MAX_NAME_LENGTH. If length is 0, the name
        * parameter is ignored (it can be NULL), and the nickname is set back to empty.
        *
        * @param name A byte array containing the new nickname.
        * @param length The size of the name byte array.
        *
        * @return true on success.
        */
        private bool self_set_name (uint8[] name, TOX_ERR_SET_INFO error);
        public void set_name (string name)
        requires (name.data.length <= MAX_NAME_LENGTH)
        {
            TOX_ERR_SET_INFO error;
            self_set_name (name.data, error);
        }

        /**
         * Write the nickname set by tox_self_set_name to a byte array.
         *
         * If no nickname was set before calling this function, the name is empty,
         * and this function has no effect.
         *
         * Call tox_self_get_name_size to find out how much memory to allocate for
         * the result.
         *
         * @param name A valid memory location large enough to hold the nickname.
         *   If this parameter is NULL, the function has no effect.
         */
        private void self_get_name ([CCode (array_length = false)] uint8[] name);
        private size_t self_get_name_size ();
        public string get_name () {
            uint8[] name = new uint8[self_get_name_size ()];
            self_get_name (name);
            return arr2str (name);
        }

        /**
         * Set the client's status message.
         *
         * Status message length cannot exceed TOX_MAX_STATUS_MESSAGE_LENGTH. If
         * length is 0, the status parameter is ignored (it can be NULL), and the
         * user status is set back to empty.
         */
        private bool self_set_status_message (uint8[] status_message, TOX_ERR_SET_INFO error);
        public bool set_status_message (string status_message)
        requires (status_message.data.length <= MAX_STATUS_MESSAGE_LENGTH)
        {
            TOX_ERR_SET_INFO error;
            return self_set_status_message (status_message.data, error);
        }

        /**
         * Return the length of the current status message as passed to tox_self_set_status_message.
         *
         * If no status message was set before calling this function, the status
         * is empty, and this function returns 0.
         *
         * @see threading for concurrency implications.
         */
        private size_t self_get_status_message_size ();

        /**
         * Write the status message set by tox_self_set_status_message to a byte array.
         *
         * If no status message was set before calling this function, the status is
         * empty, and this function has no effect.
         *
         * Call tox_self_get_status_message_size to find out how much memory to allocate for
         * the result.
         *
         * @param status A valid memory location large enough to hold the status message.
         *   If this parameter is NULL, the function has no effect.
         */
        private void self_get_status_message ([CCode (array_length=false)] uint8[] status_message);
        public string get_status_message () {
            size_t size = self_get_status_message_size ();
            uint8[] status = new uint8[size];
            self_get_status_message (status);
            return arr2str (status);
        }

        /**
         * @brief Creates and initialises a new Tox instance with the options passed.
         *
         * This function will bring the instance into a valid state. Running the event
         * loop with a new instance will operate correctly.
         *
         * If loading failed or succeeded only partially, the new or partially loaded
         * instance is returned and an error code is set.
         *
         * @param options An options object as described above, or null to default to
         *   the default options.
         *
         * @see iterate() for the event loop.
         *
         * @return A new Tox instance pointer on success or null on failure.
         */
        [CCode (cname = "tox_new")]
        private Tox tox_new (Options? options = null, out TOX_ERR_NEW? error = null);
        public Tox (Options? options = null)
        throws ConstructError
        {
            TOX_ERR_NEW error;
            tox_new (options, out error);

            switch (error) {
            case TOX_ERR_NEW.NULL:
                throw new ConstructError.UNKNOWN ("A parameter was null");
                break;
            case TOX_ERR_NEW.MALLOC:
                throw new ConstructError.UNKNOWN ("Unable to allocate memory for the Tox instance");
                break;
            case TOX_ERR_NEW.PORT_ALLOC:
                throw new ConstructError.BAD_PORT_ALLOC ("%s: Unable to seize the received port".printf (error.to_string ()));
                break;
            case TOX_ERR_NEW.PROXY_BAD_HOST:
                throw new ConstructError.BAD_HOST ("Invalid host (host was %s)".printf ((options.proxy_host ?? "null")));
                break;
            case TOX_ERR_NEW.PROXY_BAD_PORT:
                throw new ConstructError.PORT_UNAVAILABLE ("Port not available (%s)".printf (options.proxy_port.to_string ()));
                break;
            case TOX_ERR_NEW.PROXY_NOT_FOUND:
                throw new ConstructError.PROXY_NOT_FOUND ("Unable to connect to the proxy (TYPE_%s : %s)".printf (options.proxy_type.to_string (), options.proxy_host ?? "null"));
                break;
            case TOX_ERR_NEW.LOAD_ENCRYPTED:
                throw new ConstructError.ENCRYPTED_DATA ("Data was unexpectedly encrypted or looks encrypted");
                break;
            case TOX_ERR_NEW.LOAD_BAD_FORMAT:
                throw new ConstructError.MALFORMED_DATA ("Data was not properly formatted");
                break;
            default:
                throw new ConstructError.UNKNOWN (error.to_string ());
                break;
            }

            //return handle;
        }

        /*******************************************************************************
         *
         * :: Connection lifecycle and event loop
         *
         ******************************************************************************/

        /**
        * Sends a "get nodes" request to the given bootstrap node with IP, port, and
        * public key to setup connections.
        *
        * This function will attempt to connect to the node using UDP. You must use
        * this function even if Tox_Options.udp_enabled was set to false.
        *
        * @param address The hostname or IP address (IPv4 or IPv6) of the node.
        * @param port The port on the host on which the bootstrap Tox instance is
        *   listening.
        * @param public_key The long term public key of the bootstrap node
        *   (TOX_PUBLIC_KEY_SIZE bytes).
        * @return true on success.
        */
        [CCode (cname="tox_bootstrap")]
        private bool _bootstrap (
            string address,
            uint16 port,
            [CCode (array_length=false)] uint8[] public_key,
            TOX_ERR_BOOTSTRAP error
        );

        [CCode (cname="vala_tox_bootstrap")]
        public void bootstrap (string address, uint16 port, uint8[] public_key) throws BootstrapError {
            TOX_ERR_BOOTSTRAP error;
            bool result = _bootstrap (address, port, public_key, error);

            if (!result) {
                switch (error) {
                case TOX_ERR_BOOTSTRAP.BAD_HOST:
                    throw new BootstrapError.BAD_HOST("Host %s is invalid.".printf (address));
                    break;
                case TOX_ERR_BOOTSTRAP.BAD_PORT:
                    throw new BootstrapError.BAD_PORT("Port %d not valid or closed.".printf (port));
                    break;
                default:
                    throw new BootstrapError.BAD_HOST("Unable to connect, please check bootstrap parameters");
                    break;
                }
            }
        }

        /**
         * Adds additional host:port pair as TCP relay.
         *
         * This function can be used to initiate TCP connections to different ports on
         * the same bootstrap node, or to add TCP relays without using them as
         * bootstrap nodes.
         *
         * @param address The hostname or IP address (IPv4 or IPv6) of the TCP relay.
         * @param port The port on the host on which the TCP relay is listening.
         * @param public_key The long term public key of the TCP relay
         *   (TOX_PUBLIC_KEY_SIZE bytes).
         * @return true on success.
         */
        [CCode (cname="tox_add_tcp_relay")]
        private bool _add_tcp_relay (
            string address,
            uint16 port,
            [CCode (array_length=false)] uint8[] public_key,
            TOX_ERR_BOOTSTRAP error
        );

        [CCode (cname="vala_tox_add_tcp_relay")]
        public void add_tcp_relay (string address, uint16 port, uint8[] public_key)
        throws BootstrapError
        requires (public_key.length == PUBLIC_KEY_SIZE)
        {
            TOX_ERR_BOOTSTRAP error;
            bool result = _add_tcp_relay (address, port, public_key, error);

            if (!result) {
                switch (error) {
                case TOX_ERR_BOOTSTRAP.BAD_HOST:
                    throw new BootstrapError.BAD_HOST("Relay Host %s is invalid.".printf (address));
                    break;
                case TOX_ERR_BOOTSTRAP.BAD_PORT:
                    throw new BootstrapError.BAD_PORT("Port %d not valid or closed.".printf (port));
                    break;
                default:
                    throw new BootstrapError.BAD_HOST("Unable to connect, please check relay parameters");
                    break;
                }
            }
        }

        /**
         * Return whether we are connected to the DHT. The return value is equal to the
         * last value received through the `self_connection_status` callback.
         */
        [CCode (cname="tox_self_get_connection_status")]
        public ConnectionStatus get_connection_status ();
        public delegate void ConnectionStatusFunc (Tox handle, ConnectionStatus status);

        /**
         * Set the callback for the `self_connection_status` event. Pass null to unset.
         *
         * This event is triggered whenever there is a change in the DHT connection
         * state. When disconnected, a client may choose to call tox_bootstrap again, to
         * reconnect to the DHT. Note that this state may frequently change for short
         * amounts of time. Clients should therefore not immediately bootstrap on
         * receiving a disconnect.
         *
         * TODO: how long should a client wait before bootstrapping again?
         */
        [CCode (cname="callback_connection_status")]
        public void connection_status_callback (ConnectionStatusFunc callback);

        /**
         * Return the time in milliseconds before iterate() should be called again
         * for optimal performance.
         */
        public uint32 iteration_interval ();

        /**
         * The main loop that needs to be run in intervals of iteration_interval()
         * milliseconds.
         */
        public void iterate ();

        /*******************************************************************************
         *
         * :: Friend list management
         *
         ******************************************************************************/

        /**
         * Add a friend to the friend list and send a friend request.
         *
         * A friend request message must be at least 1 byte long and at most
         * TOX_MAX_FRIEND_REQUEST_LENGTH.
         *
         * Friend numbers are unique identifiers used in all functions that operate on
         * friends. Once added, a friend number is stable for the lifetime of the Tox
         * object. After saving the state and reloading it, the friend numbers may not
         * be the same as before. Deleting a friend creates a gap in the friend number
         * set, which is filled by the next adding of a friend. Any pattern in friend
         * numbers should not be relied on.
         *
         * If more than INT32_MAX friends are added, this function causes undefined
         * behaviour.
         *
         * @param address The address of the friend (returned by tox_self_get_address of
         *   the friend you wish to add) it must be TOX_ADDRESS_SIZE bytes.
         * @param message The message that will be sent along with the friend request.
         * @param length The length of the data byte array.
         *
         * @return the friend number on success, UINT32_MAX on failure.
         */
        private uint32 friend_add (
            [CCode (array_length=false)] uint8[] address,
            uint8[] message,
            TOX_ERR_FRIEND_ADD error
        );

        public uint32 add_friend (uint8[] address, string message)
        throws FriendAddError
        requires (message.data.length <= MAX_FRIEND_REQUEST_LENGTH)
        requires (message.data.length > 0)
        requires (address.length == ADDRESS_SIZE)
        {
            TOX_ERR_FRIEND_ADD error;
            uint32 friend_number = friend_add (address, message.data, error);

            switch (error) {
            case TOX_ERR_FRIEND_ADD.OWN_KEY:
                throw new FriendAddError.OWNKEY ("The provided key is the same client key");
                break;
            case TOX_ERR_FRIEND_ADD.ALREADY_SENT:
                throw new FriendAddError.ALREADYSENT ("The provided key belongs to an already addede friend");
                break;
            case TOX_ERR_FRIEND_ADD.BAD_CHECKSUM:
                throw new FriendAddError.BADCHECKSUM ("Checksum was invalid");
                break;
            case TOX_ERR_FRIEND_ADD.SET_NEW_NOSPAM:
                throw new FriendAddError.SETNEWNOSPAM ("Client was already added, changed the nospam value");
                break;
            case TOX_ERR_FRIEND_ADD.MALLOC:
                throw new FriendAddError.NOMEM ("Error allocating the friend request");
                break;
            default:
                throw new FriendAddError.UNKNOWN ("Unknown error, please check the request parameters");
                break;
            }

            return friend_number;
        }

        /**
         * Add a friend without sending a friend request.
         *
         * This function is used to add a friend in response to a friend request. If the
         * client receives a friend request, it can be reasonably sure that the other
         * client added this client as a friend, eliminating the need for a friend
         * request.
         *
         * This function is also useful in a situation where both instances are
         * controlled by the same entity, so that this entity can perform the mutual
         * friend adding. In this case, there is no need for a friend request, either.
         *
         * @param public_key A byte array of length TOX_PUBLIC_KEY_SIZE containing the
         *   Public Key (not the Address) of the friend to add.
         *
         * @return the friend number on success, UINT32_MAX on failure.
         * @see tox_friend_add for a more detailed description of friend numbers.
         */
        private uint32 friend_add_norequest (
            [CCode (array_length=false)] uint8[] public_key,
            TOX_ERR_FRIEND_ADD error
        );

        public uint32 add_friend_norequest (uint8[] public_key) throws FriendAddError {
            TOX_ERR_FRIEND_ADD error;
            uint32 friend_number = friend_add_norequest (public_key, error);

            switch (error) {
            case TOX_ERR_FRIEND_ADD.OWN_KEY:
                throw new FriendAddError.OWNKEY ("The provided key is the same client key");
                break;
            case TOX_ERR_FRIEND_ADD.ALREADY_SENT:
                throw new FriendAddError.ALREADYSENT ("The provided key belongs to an already addede friend");
                break;
            case TOX_ERR_FRIEND_ADD.BAD_CHECKSUM:
                throw new FriendAddError.BADCHECKSUM ("Checksum was invalid");
                break;
            case TOX_ERR_FRIEND_ADD.SET_NEW_NOSPAM:
                throw new FriendAddError.SETNEWNOSPAM ("Client was already added, changed the nospam value");
                break;
            case TOX_ERR_FRIEND_ADD.MALLOC:
                throw new FriendAddError.NOMEM ("Error allocating the friend request");
            default:
                throw new FriendAddError.UNKNOWN ("Unknown error, please check the request parameters");
                break;
            }

            return friend_number;
        }

        /**
         * Remove a friend from the friend list.
         *
         * This does not notify the friend of their deletion. After calling this
         * function, this client will appear offline to the friend and no communication
         * can occur between the two.
         *
         * @param friend_number Friend number for the friend to be deleted.
         *
         * @return true on success.
         */
        private bool friend_delete (uint32 friend_number, TOX_ERR_FRIEND_DELETE error);
        public bool delete_friend (uint32 friend_number) {
            TOX_ERR_FRIEND_DELETE error;
            return friend_delete (friend_number, error);
        }

        /*******************************************************************************
         *
         * :: Friend list queries
         *
         ******************************************************************************/

        /**
        * Return the friend number associated with that Public Key.
        *
        * @return the friend number on success, UINT32_MAX on failure.
        * @param public_key A byte array containing the Public Key.
        */
        private uint32 friend_by_public_key (
            [CCode (array_length=false)] uint8[] public_key,
            TOX_ERR_FRIEND_BY_PUBLIC_KEY error
        );

        public uint32 get_friend_by_public_key (uint8[] public_key) throws FriendGetError {
            TOX_ERR_FRIEND_BY_PUBLIC_KEY error;
            uint32 friend_number = friend_by_public_key (public_key, error);

            switch (error) {
            case TOX_ERR_FRIEND_BY_PUBLIC_KEY.NOT_FOUND:
                throw new FriendGetError.NOT_FOUND ("The provided public key doesn't belong to a friend.");
                break;
            default:
                break;
            }

            return friend_number;
        }

        /**
         * Checks if a friend with the given friend number exists and returns true if
         * it does.
         */
        public bool friend_exists (uint32 friend_number);

        /**
         * Return the number of friends on the friend list.
         *
         * This function can be used to determine how much memory to allocate for
         * tox_self_get_friend_list.
         */
        private size_t self_get_friend_list_size ();

        /**
         * Copy a list of valid friend numbers into an array.
         *
         * Call tox_self_get_friend_list_size to determine the number of elements to allocate.
         *
         * @param list A memory region with enough space to hold the friend list. If
         *   this parameter is NULL, this function has no effect.
         */
        private void self_get_friend_list ([CCode (array_length = false)] uint32[] friend_list);

        public uint32[] get_friend_list () {
            uint32[] retval = new uint32[self_get_friend_list_size ()];
            self_get_friend_list (retval);
            return retval;
        }

        /**
         * Copies the Public Key associated with a given friend number to a byte array.
         *
         * @param friend_number The friend number you want the Public Key of.
         * @param public_key A memory region of at least TOX_PUBLIC_KEY_SIZE bytes. If
         *   this parameter is NULL, this function has no effect.
         *
         * @return true on success.
         */
        private bool friend_get_public_key (
            uint32 friend_number,
            [CCode (array_length=false)] uint8[] public_key,
            TOX_ERR_FRIEND_GET_PUBLIC_KEY error
        );

        public uint8[] get_friend_public_key (uint32 friend_number) {
            TOX_ERR_FRIEND_GET_PUBLIC_KEY error;
            uint8[] retval = new uint8[PUBLIC_KEY_SIZE];
            bool friend_pkey = friend_get_public_key (friend_number, retval, error);

            if (!friend_pkey) {
                throw new FriendGetError.NOT_FOUND ("Friend number %u is not valid.".printf (friend_number));
            }

            return retval;
        }

        /**
         * Return a unix-time timestamp of the last time the friend associated with a given
         * friend number was seen online. This function will return UINT64_MAX on error.
         *
         * @param friend_number The friend number you want to query.
         */
        private uint64 friend_get_last_online (uint32 friend_number, TOX_ERR_FRIEND_GET_LAST_ONLINE error);
        public uint64 get_friend_last_online (uint32 friend_number) throws FriendGetError {
            TOX_ERR_FRIEND_GET_LAST_ONLINE error;
            uint64 retval = friend_get_last_online (friend_number, error);

            if (retval == uint64.MAX) {
                throw new FriendGetError.NOT_FOUND ("Unable to get the last seen time, friend_number %u seems invalid.".printf (friend_number));
            }

            return retval;
        }

        /*******************************************************************************
         *
         * :: Friend-specific state queries (can also be received through callbacks)
         *
         ******************************************************************************/


        /**
         * Return the length of the friend's name. If the friend number is invalid, the
         * return value is unspecified.
         *
         * The return value is equal to the `length` argument received by the last
         * `friend_name` callback.
         */
        private size_t friend_get_name_size (uint32 friend_number, TOX_ERR_FRIEND_QUERY error);

        /**
         * Write the name of the friend designated by the given friend number to a byte
         * array.
         *
         * Call tox_friend_get_name_size to determine the allocation size for the `name`
         * parameter.
         *
         * The data written to `name` is equal to the data received by the last
         * `friend_name` callback.
         *
         * @param name A valid memory region large enough to store the friend's name.
         *
         * @return true on success.
         */
        private bool friend_get_name (
            uint32 friend_number,
            [CCode (array_length=false)] uint8[] name,
            TOX_ERR_FRIEND_QUERY error
        );

        public string get_friend_name (uint32 friend_number) throws FriendGetError {
            TOX_ERR_FRIEND_QUERY error;
            size_t size = friend_get_name_size (friend_number, error);

            if (error == TOX_ERR_FRIEND_QUERY.NOT_FOUND) {
                throw new FriendGetError.NOT_FOUND ("Friend number %u is invalid".printf (friend_number));
            }

            uint8[] name = new uint8[size];
            bool val = friend_get_name (friend_number, name, error);

            if (!val) {
                throw new FriendGetError.UNKNOWN ("Unknown error on getting the name.");
            }

            return arr2str (name);
        }

        /**
         * @param friend_number The friend number of the friend whose name changed.
         * @param name A byte array containing the same data as
         *   tox_friend_get_name would write to its `name` parameter.
         * @param length A value equal to the return value of
         *   tox_friend_get_name_size.
         */
        [CCode (cname="tox_friend_name_cb")]
        public delegate void FriendNameFunc (Tox handle, uint32 friend_number, uint8[] name);

        /**
         * Set the callback for the `friend_name` event. Pass NULL to unset.
         *
         * This event is triggered when a friend changes their name.
         */
        [CCode (cname="tox_callback_friend_name")]
        public void friend_name_callback (FriendNameFunc callback);

        /**
         * Return the length of the friend's status message. If the friend number is
         * invalid, the return value is SIZE_MAX.
         */
        private size_t friend_get_status_message_size (uint32 friend_number, TOX_ERR_FRIEND_QUERY error);

        /**
         * Write the status message of the friend designated by the given friend number to a byte
         * array.
         *
         * Call tox_friend_get_status_message_size to determine the allocation size for the `status_name`
         * parameter.
         *
         * The data written to `status_message` is equal to the data received by the last
         * `friend_status_message` callback.
         *
         * @param status_message A valid memory region large enough to store the friend's status message.
         */
        private bool friend_get_status_message (
            uint32 friend_number,
            [CCode (array_length=false)] uint8[] status_message,
            TOX_ERR_FRIEND_QUERY error
        );

        public string get_friend_status_message (uint32 friend_number) throws FriendGetError {
            TOX_ERR_FRIEND_QUERY error;
            size_t size = friend_get_status_message_size (friend_number, error);

            if (error == TOX_ERR_FRIEND_QUERY.NOT_FOUND) {
                throw new FriendGetError.NOT_FOUND ("Friend number %u not found".printf (friend_number));
            }

            uint8[] retval = new uint8[size];
            bool val = friend_get_status_message (friend_number, retval, error);

            if (!val) {
                throw new FriendGetError.UNKNOWN ("Unknown error, please check get_friend_status_message params");
            }

            return arr2str (retval);
        }

        /**
         * @param friend_number The friend number of the friend whose status message
         *   changed.
         * @param message A byte array containing the same data as
         *   tox_friend_get_status_message would write to its `status_message` parameter.
         * @param length A value equal to the return value of
         *   tox_friend_get_status_message_size.
         */
        [CCode (cname="tox_friend_status_message_cb")]
        public delegate void FriendStatusMessageFunc (Tox handle, uint32 friend_number, uint8[] message);

        /**
         * Set the callback for the `friend_status_message` event. Pass NULL to unset.
         *
         * This event is triggered when a friend changes their status message.
         */
        [CCode (cname="tox_callback_friend_status_message")]
        public void friend_status_message_callback (FriendStatusMessageFunc callback);

        /**
         * Return the friend's user status (away/busy/...). If the friend number is
         * invalid, the return value is unspecified.
         *
         * The status returned is equal to the last status received through the
         * `friend_status` callback.
         */
        private UserStatus friend_get_status (uint32 friend_number, TOX_ERR_FRIEND_QUERY error);
        public UserStatus get_friend_status (uint32 friend_number) throws FriendGetError {
            TOX_ERR_FRIEND_QUERY error;
            UserStatus retval = friend_get_status (friend_number, error);

            if (error == TOX_ERR_FRIEND_QUERY.NOT_FOUND) {
                throw new FriendGetError.NOT_FOUND ("Friend number %u not found".printf (friend_number));
            }

            return retval;
        }

        /**
         * @param friend_number The friend number of the friend whose user status
         *   changed.
         * @param status The new user status.
         */
        [CCode (cname="tox_friend_status_cb")]
        public delegate void FriendStatusFunc (Tox handle, uint32 friend_number, UserStatus status);

        /**
         * Set the callback for the `friend_status` event. Pass NULL to unset.
         *
         * This event is triggered when a friend changes their user status.
         */
        [CCode (cname="tox_callback_friend_status")]
        public void friend_status_callback (FriendStatusFunc callback);

        /**
         * Check whether a friend is currently connected to this client.
         *
         * The result of this function is equal to the last value received by the
         * `friend_connection_status` callback.
         *
         * @param friend_number The friend number for which to query the connection
         *   status.
         *
         * @return the friend's connection status as it was received through the
         *   `friend_connection_status` event.
         */
        private ConnectionStatus friend_get_connection_status (uint32 friend_number, TOX_ERR_FRIEND_QUERY error);
        public ConnectionStatus get_friend_connection_status (uint32 friend_number) throws FriendGetError {
            TOX_ERR_FRIEND_QUERY error;
            ConnectionStatus retval = friend_get_connection_status (friend_number, error);

            if (error == TOX_ERR_FRIEND_QUERY.NOT_FOUND) {
                throw new FriendGetError.NOT_FOUND ("Friend number %u not found".printf (friend_number));
            }

            return retval;
        }

        /**
         * @param friend_number The friend number of the friend whose connection status
         *   changed.
         * @param connection_status The result of calling
         *   tox_friend_get_connection_status on the passed friend_number.
         */
        [CCode (cname="tox_friend_connection_status_cb")]
        public delegate void FriendConnectionStatusFunc (Tox handle, uint32 friend_number, ConnectionStatus status);

        /**
         * Set the callback for the `friend_connection_status` event. Pass NULL to unset.
         *
         * This event is triggered when a friend goes offline after having been online,
         * or when a friend goes online.
         *
         * This callback is not called when adding friends. It is assumed that when
         * adding friends, their connection status is initially offline.
         */
        [CCode (cname="tox_callback_friend_connection_status")]
        public void friend_connection_status_callback (FriendConnectionStatusFunc callback);

        /**
         * Check whether a friend is currently typing a message.
         *
         * @param friend_number The friend number for which to query the typing status.
         *
         * @return true if the friend is typing.
         * @return false if the friend is not typing, or the friend number was
         *   invalid. Inspect the error code to determine which case it is.
         */
        private bool friend_get_typing (uint32 friend_number, TOX_ERR_FRIEND_QUERY error);
        public bool friend_is_typing (uint32 friend_number) throws FriendGetError {
            TOX_ERR_FRIEND_QUERY error;
            bool retval = friend_get_typing (friend_number, error);

            if (error == TOX_ERR_FRIEND_QUERY.NOT_FOUND) {
                throw new FriendGetError.NOT_FOUND ("Friend number %u not found".printf (friend_number));
            }

            return retval;
        }

        /**
         * @param friend_number The friend number of the friend who started or stopped
         *   typing.
         * @param is_typing The result of calling tox_friend_get_typing on the passed
         *   friend_number.
         */
        [CCode (cname = "tox_friend_typing_cb")]
        public delegate void FriendTypingFunc (Tox handle, uint32 friend_number, bool is_typing);

        /**
         * Set the callback for the `friend_typing` event. Pass NULL to unset.
         *
         * This event is triggered when a friend starts or stops typing.
         */
        [CCode (cname="tox_callback_friend_typing")]
        public void friend_typing_callback (FriendTypingFunc callback);

        /*******************************************************************************
         *
         * :: Sending private messages
         *
         ******************************************************************************/

        /**
         * Set the client's typing status for a friend.
         *
         * The client is responsible for turning it on or off.
         *
         * @param friend_number The friend to which the client is typing a message.
         * @param typing The typing status. True means the client is typing.
         *
         * @return true on success.
         */
        private bool self_set_typing (uint32 friend_number, bool is_typing, TOX_ERR_FRIEND_DELETE error);
        public bool set_typing_for_friend (uint32 friend_number, bool is_typing) {
            TOX_ERR_FRIEND_DELETE error;
            bool retval = self_set_typing (friend_number, is_typing, error);

            /*if (error == TOX_ERR_FRIEND_DELETE.NOT_FOUND) {
                throw new FriendGetError.NOT_FOUND ("Friend number %u not found".printf (friend_number));
            }*/

            return retval;
        }

        /**
         * Send a text chat message to an online friend.
         *
         * This function creates a chat message packet and pushes it into the send
         * queue.
         *
         * The message length may not exceed TOX_MAX_MESSAGE_LENGTH. Larger messages
         * must be split by the client and sent as separate messages. Other clients can
         * then reassemble the fragments. Messages may not be empty.
         *
         * The return value of this function is the message ID. If a read receipt is
         * received, the triggered `friend_read_receipt` event will be passed this message ID.
         *
         * Message IDs are unique per friend. The first message ID is 0. Message IDs are
         * incremented by 1 each time a message is sent. If UINT32_MAX messages were
         * sent, the next message ID is 0.
         *
         * @param type Message type (normal, action, ...).
         * @param friend_number The friend number of the friend to send the message to.
         * @param message A non-NULL pointer to the first element of a byte array
         *   containing the message text.
         * @param length Length of the message to be sent.
         */
        private uint32 friend_send_message (
            uint32 friend_number,
            MessageType type,
            uint8[] message,
            TOX_ERR_FRIEND_SEND_MESSAGE error
        );

        public uint32 send_friend_message (uint32 friend_number, MessageType type, string message)
        throws SendMessageError
        requires (message.length > 0)
        requires (message.data.length < MAX_MESSAGE_LENGTH)
        {
            TOX_ERR_FRIEND_SEND_MESSAGE error;
            uint32 retval = friend_send_message (friend_number, type, message.data, error);

            switch (error) {
            case TOX_ERR_FRIEND_SEND_MESSAGE.FRIEND_NOT_FOUND:
                throw new SendMessageError.FRIEND_NOT_FOUND ("Friend number %u not found".printf (friend_number));
                break;
            case TOX_ERR_FRIEND_SEND_MESSAGE.FRIEND_NOT_CONNECTED:
                throw new SendMessageError.FRIEND_NOT_CONNECTED ("Friend number %u not connected, maybe try to queue it for later?".printf (friend_number));
                break;
            case TOX_ERR_FRIEND_SEND_MESSAGE.SENDQ:
                throw new SendMessageError.SENDQ ("Error increasing the message queue size for friend number %u".printf (friend_number));
            default:
                break;
            }

            return retval;
        }

        /**
         * @param friend_number The friend number of the friend who received the message.
         * @param message_id The message ID as returned from tox_friend_send_message
         *   corresponding to the message sent.
         */
        [CCode (cname = "tox_friend_read_receipt_cb")]
        public delegate void ReadReceiptFunc(Tox handle, uint32 friend_number, uint32 message_id);

        /**
         * Set the callback for the `friend_read_receipt` event. Pass NULL to unset.
         *
         * This event is triggered when the friend receives the message sent with
         * tox_friend_send_message with the corresponding message ID.
         */
        [CCode (cname="tox_callback_friend_read_receipt")]
        public void friend_read_receipt_callback (ReadReceiptFunc callback);

        /*******************************************************************************
         *
         * :: Receiving private messages and friend requests
         *
         ******************************************************************************/

        /**
         * @param public_key The Public Key of the user who sent the friend request.
         * @param time_delta A delta in seconds between when the message was composed
         *   and when it is being transmitted. For messages that are sent immediately,
         *   it will be 0. If a message was written and couldn't be sent immediately
         *   (due to a connection failure, for example), the time_delta is an
         *   approximation of when it was composed.
         * @param message The message they sent along with the request.
         * @param length The size of the message byte array.
         */
        [CCode (cname="tox_friend_request_cb")]
        public delegate void FriendRequestFunc (
            Tox handle,
            [CCode (array_length = false)] uint8 public_key,
            uint8[] message
        );

        /**
         * Set the callback for the `friend_request` event. Pass NULL to unset.
         *
         * This event is triggered when a friend request is received.
         */
        [CCode (cname="tox_callback_friend_request")]
        public void friend_request_callback (FriendRequestFunc callback);

        /**
         * @param friend_number The friend number of the friend who sent the message.
         * @param time_delta Time between composition and sending.
         * @param message The message data they sent.
         * @param length The size of the message byte array.
         *
         * @see friend_request for more information on time_delta.
         */
        [CCode (cname="tox_friend_message_cb")]
        public delegate void FriendMessageFunc (
            Tox handle,
            uint32 friend_number,
            MessageType type,
            uint8[] message
        );

        /**
         * Set the callback for the `friend_message` event. Pass NULL to unset.
         *
         * This event is triggered when a message from a friend is received.
         */
        [CCode (cname="tox_callback_friend_message")]
        public void friend_message_callback (FriendMessageFunc callback);

        /*******************************************************************************
         *
         * :: File transmission: common between sending and receiving
         *
         ******************************************************************************/

        /**
         * Generates a cryptographic hash of the given data.
         *
         * This function may be used by clients for any purpose, but is provided
         * primarily for validating cached avatars. This use is highly recommended to
         * avoid unnecessary avatar updates.
         *
         * If hash is NULL or data is NULL while length is not 0 the function returns false,
         * otherwise it returns true.
         *
         * This function is a wrapper to internal message-digest functions.
         *
         * @param hash A valid memory location the hash data. It must be at least
         *   TOX_HASH_LENGTH bytes in size.
         * @param data Data to be hashed or NULL.
         * @param length Size of the data array or 0.
         *
         * @return true if hash was not NULL.
         */
        [CCode (cname="tox_hash")]
        private bool _hash ([CCode (array_length=false)] uint8[] hash, uint8[] data);

        [CCode (cname="vala_tox_hash")]
        public uint8[]? hash (uint8[] data) {
            uint8[] retval = new uint8[HASH_LENGTH];
            _hash (retval, data);
            return retval;
        }

        /**
         * Sends a file control command to a friend for a given file transfer.
         *
         * @param friend_number The friend number of the friend the file is being
         *   transferred to or received from.
         * @param file_number The friend-specific identifier for the file transfer.
         * @param control The control command to send.
         *
         * @return true on success.
         */
        [CCode (cname="tox_file_control")]
        private bool _file_control (
            uint32 friend_number,
            uint32 file_number,
            FileControlStatus control,
            TOX_ERR_FILE_CONTROL error
        );

        [CCode (cname="vala_tox_file_control")]
        public void file_control (uint32 friend_number, uint32 file_number, FileControlStatus status)
        throws FileControlStatus
        {
            TOX_ERR_FILE_CONTROL error;
            bool res = _file_control (friend_number, file_number, status, error);

            if (!res) {
                switch (error) {
                case TOX_ERR_FILE_CONTROL.FRIEND_NOT_FOUND:
                    throw new FileControlError.FRIEND_NOT_FOUND ("Friend number %u not found".printf (friend_number));
                    break;
                case TOX_ERR_FILE_CONTROL.FRIEND_NOT_CONNECTED:
                    throw new FileControlError.FRIEND_NOT_CONNECTED ("Friend number %u is not connected".printf (friend_number));
                    break;
                case TOX_ERR_FILE_CONTROL.NOT_FOUND:
                    throw new FileControlError.NOT_FOUND ("File transfer ID %u not found".printf (file_number));
                    break;
                case TOX_ERR_FILE_CONTROL.NOT_PAUSED:
                    throw new FileControlError.NOT_PAUSED ("File transter ID %u not found".printf (file_number));
                    break;
                case TOX_ERR_FILE_CONTROL.DENIED:
                    throw new FileControlError.DENIED ("File transfer ID %u was paused by the other party".printf (file_number));
                    break;
                case TOX_ERR_FILE_CONTROL.ALREADY_PAUSED:
                    throw new FileControlError.ALREADY_PAUSED ("File transfer ID %u was already paused".printf (file_number));
                    break;
                case TOX_ERR_FILE_CONTROL.SENDQ:
                    throw new FileControlError.SENDQ ("Packet Queue is full, please retry later");
                    break;
                default:
                    break;
                }
            }
        }

        /**
         * When receiving TOX_FILE_CONTROL_CANCEL, the client should release the
         * resources associated with the file number and consider the transfer failed.
         *
         * @param friend_number The friend number of the friend who is sending the file.
         * @param file_number The friend-specific file number the data received is
         *   associated with.
         * @param control The file control command received.
         */
        [CCode (cname = "tox_file_recv_control_cb")]
        public delegate void FileControlReceiveFunc (
            Tox handle,
            uint32 friend_number,
            uint32 file_number,
            FileControlStatus status
        );

        /**
         * Set the callback for the `file_recv_control` event. Pass NULL to unset.
         *
         * This event is triggered when a file control command is received from a
         * friend.
         */
        [CCode (cname = "tox_callback_file_recv_control")]
        public void file_recv_control_callback (FileControlReceiveFunc callback);

        /**
         * Sends a file seek control command to a friend for a given file transfer.
         *
         * This function can only be called to resume a file transfer right before
         * TOX_FILE_CONTROL_RESUME is sent.
         *
         * @param friend_number The friend number of the friend the file is being
         *   received from.
         * @param file_number The friend-specific identifier for the file transfer.
         * @param position The position that the file should be seeked to.
         */
        [CCode (cname = "tox_file_seek")]
        private bool _file_seek (
            uint32 friend_number,
            uint32 file_number,
            uint64 position,
            TOX_ERR_FILE_SEEK error
        );

        [CCode (cname = "vala_tox_file_seek")]
        public void file_seek (uint32 friend_number, uint32 file_number, uint16 position) throws FileSeekError {
            TOX_ERR_FILE_SEEK error;
            bool res = _file_seek (friend_number, file_number, position, error);

            if (!res) {
                switch (error) {
                case TOX_ERR_FILE_SEEK.FRIEND_NOT_FOUND:
                    throw new FileSeekError.FRIEND_NOT_FOUND ("Friend number %u not found".printf (friend_number));
                    break;
                case TOX_ERR_FILE_SEEK.FRIEND_NOT_CONNECTED:
                    throw new FileSeekError.FRIEND_NOT_CONNECTED ("Friend number %u is not connected".printf (friend_number));
                default:
                    break;
                }
            }
        }

        /**
         * Copy the file id associated to the file transfer to a byte array.
         *
         * @param friend_number The friend number of the friend the file is being
         *   transferred to or received from.
         * @param file_number The friend-specific identifier for the file transfer.
         * @param file_id A memory region of at least TOX_FILE_ID_LENGTH bytes. If
         *   this parameter is NULL, this function has no effect.
         *
         * @return true on success.
         */
        private bool file_get_file_id (
            uint32 friend_number,
            uint32 file_number,
            [CCode (array_length=false)] uint8[] file_id,
            TOX_ERR_FILE_GET error
        );

        public uint8[] get_file_id (uint32 friend_number, uint32 file_number) throws FileGetError {
            TOX_ERR_FILE_GET error;
            uint8[] retval = new uint8[FILE_ID_LENGTH];
            bool res = file_get_file_id (friend_number, file_number, retval, error);

            if (!res) {
                switch (error) {
                case TOX_ERR_FILE_GET.FRIEND_NOT_FOUND:
                    throw new FileGetError.FRIEND_NOT_FOUND ("Friend number %u not found".printf (friend_number));
                    break;
                case TOX_ERR_FILE_GET.NOT_FOUND:
                    throw new FileGetError.NOT_FOUND ("File number %u not valid".printf (file_number));
                    break;
                default:
                    break;
                }
            }

            return retval;
        }

        /*******************************************************************************
         *
         * :: File transmission: sending
         *
         ******************************************************************************/

        /**
         * Send a file transmission request.
         *
         * Maximum filename length is TOX_MAX_FILENAME_LENGTH bytes. The filename
         * should generally just be a file name, not a path with directory names.
         *
         * If a non-UINT64_MAX file size is provided, it can be used by both sides to
         * determine the sending progress. File size can be set to UINT64_MAX for streaming
         * data of unknown size.
         *
         * File transmission occurs in chunks, which are requested through the
         * `file_chunk_request` event.
         *
         * When a friend goes offline, all file transfers associated with the friend are
         * purged from core.
         *
         * If the file contents change during a transfer, the behaviour is unspecified
         * in general. What will actually happen depends on the mode in which the file
         * was modified and how the client determines the file size.
         *
         * - If the file size was increased
         *   - and sending mode was streaming (file_size = UINT64_MAX), the behaviour
         *     will be as expected.
         *   - and sending mode was file (file_size != UINT64_MAX), the
         *     file_chunk_request callback will receive length = 0 when Core thinks
         *     the file transfer has finished. If the client remembers the file size as
         *     it was when sending the request, it will terminate the transfer normally.
         *     If the client re-reads the size, it will think the friend cancelled the
         *     transfer.
         * - If the file size was decreased
         *   - and sending mode was streaming, the behaviour is as expected.
         *   - and sending mode was file, the callback will return 0 at the new
         *     (earlier) end-of-file, signalling to the friend that the transfer was
         *     cancelled.
         * - If the file contents were modified
         *   - at a position before the current read, the two files (local and remote)
         *     will differ after the transfer terminates.
         *   - at a position after the current read, the file transfer will succeed as
         *     expected.
         *   - In either case, both sides will regard the transfer as complete and
         *     successful.
         *
         * @param friend_number The friend number of the friend the file send request
         *   should be sent to.
         * @param kind The meaning of the file to be sent.
         * @param file_size Size in bytes of the file the client wants to send, UINT64_MAX if
         *   unknown or streaming.
         * @param file_id A file identifier of length TOX_FILE_ID_LENGTH that can be used to
         *   uniquely identify file transfers across core restarts. If NULL, a random one will
         *   be generated by core. It can then be obtained by using tox_file_get_file_id().
         * @param filename Name of the file. Does not need to be the actual name. This
         *   name will be sent along with the file send request.
         * @param filename_length Size in bytes of the filename.
         *
         * @return A file number used as an identifier in subsequent callbacks. This
         *   number is per friend. File numbers are reused after a transfer terminates.
         *   On failure, this function returns UINT32_MAX. Any pattern in file numbers
         *   should not be relied on.
         */
        private uint32 file_send (
            uint32 friend_number,
            FileKind kind,
            uint64 file_size,
            [CCode (array_length=false)] uint8[]? file_id,
            uint8[] filename,
            TOX_ERR_FILE_SEND error
        );

        public uint32 send_file (
            uint32 friend_number,
            FileKind kind,
            uint64 file_size,
            uint8[]? file_id = new uint8[FILE_ID_LENGTH],
            string filename
        )
        throws FileSeekError
        requires (filename.data.length <= MAX_FILENAME_LENGTH)
        {
            TOX_ERR_FILE_SEND error;
            uint32 retval = file_send (friend_number, kind, file_size, file_id, filename.data, error);

            if (retval == uint32.MAX) {
                switch (error) {
                case TOX_ERR_FILE_SEND.FRIEND_NOT_FOUND:
                    throw new FileSendError.FRIEND_NOT_FOUND ("Friend number %u not found".printf (friend_number));
                    break;
                case TOX_ERR_FILE_SEND.FRIEND_NOT_CONNECTED:
                    throw new FileSendError.FRIEND_NOT_CONNECTED ("Friend number %u is not online".printf (friend_number));
                    break;
                case TOX_ERR_FILE_SEND.TOO_MANY:
                    throw new FileSendError.TOO_MANY ("Too many outgoing connections for friend number %u".printf (friend_number));
                    break;
                default:
                    break;
                }
            }

            return retval;
        }

        /**
         * Send a chunk of file data to a friend.
         *
         * This function is called in response to the `file_chunk_request` callback. The
         * length parameter should be equal to the one received though the callback.
         * If it is zero, the transfer is assumed complete. For files with known size,
         * Core will know that the transfer is complete after the last byte has been
         * received, so it is not necessary (though not harmful) to send a zero-length
         * chunk to terminate. For streams, core will know that the transfer is finished
         * if a chunk with length less than the length requested in the callback is sent.
         *
         * @param friend_number The friend number of the receiving friend for this file.
         * @param file_number The file transfer identifier returned by tox_file_send.
         * @param position The file or stream position from which to continue reading.
         * @return true on success.
         */
        private bool file_send_chunk (
            uint32 friend_number,
            uint32 file_number,
            uint64 position,
            uint8[] data,
            TOX_ERR_FILE_SEND_CHUNK error
        );

        public void send_file_chunk (
            uint32 friend_number,
            uint32 file_number,
            uint64 position,
            uint8[] data
        ) throws FileSendChunkError {
            TOX_ERR_FILE_SEND_CHUNK error;
            bool res = file_send_chunk (friend_number, file_number, position, data, error);

            if (!res) {
                switch (error) {
                case TOX_ERR_FILE_SEND_CHUNK.FRIEND_NOT_FOUND:
                    throw new FileSendChunkError.FRIEND_NOT_FOUND ("Friend number %u not found".printf (friend_number));
                    break;
                case TOX_ERR_FILE_SEND_CHUNK.FRIEND_NOT_CONNECTED:
                    throw new FileSendChunkError.FRIEND_NOT_CONNECTED ("Friend number %u is not online".printf (friend_number));
                    break;
                case TOX_ERR_FILE_SEND_CHUNK.NOT_FOUND:
                    throw new FileSendChunkError.NOT_FOUND ("File number %u not found".printf (file_number));
                    break;
                case TOX_ERR_FILE_SEND_CHUNK.NOT_TRANSFERRING:
                    throw new FileSendChunkError.NOT_TRANSFERRING ("Friend number %u is not acccepting the connection, check %u file number".printf (friend_number, file_number));
                    break;
                case TOX_ERR_FILE_SEND_CHUNK.INVALID_LENGTH:
                    throw new FileSendChunkError.INVALID_LENGTH ("Length %u is not valid for file number %u".printf (data.length, friend_number));
                    break;
                case TOX_ERR_FILE_SEND_CHUNK.SENDQ:
                    throw new FileSendChunkError.SENDQ ("Packet queue full for file number %u and friend number %u".printf (file_number, friend_number));
                    break;
                /*case TOX_ERR_FILE_SEND_CHUNK.WRONG_POSTION:
                    throw new FileSendChunkError.WRONG_POSITION ("File number %d is not in position %d".printf (file_number, position));
                    break;*/
                default:
                    break;
                }
            }
        }

        /**
         * If the length parameter is 0, the file transfer is finished, and the client's
         * resources associated with the file number should be released. After a call
         * with zero length, the file number can be reused for future file transfers.
         *
         * If the requested position is not equal to the client's idea of the current
         * file or stream position, it will need to seek. In case of read-once streams,
         * the client should keep the last read chunk so that a seek back can be
         * supported. A seek-back only ever needs to read from the last requested chunk.
         * This happens when a chunk was requested, but the send failed. A seek-back
         * request can occur an arbitrary number of times for any given chunk.
         *
         * In response to receiving this callback, the client should call the function
         * `tox_file_send_chunk` with the requested chunk. If the number of bytes sent
         * through that function is zero, the file transfer is assumed complete. A
         * client must send the full length of data requested with this callback.
         *
         * @param friend_number The friend number of the receiving friend for this file.
         * @param file_number The file transfer identifier returned by tox_file_send.
         * @param position The file or stream position from which to continue reading.
         * @param length The number of bytes requested for the current chunk.
         */
        [CCode (cname = "tox_file_chunk_request_cb")]
        public delegate void FileChunkRequestFunc (
            Tox handle,
            uint32 friend_number,
            uint32 file_number,
            uint64 position,
            size_t length
        );

        /**
         * Set the callback for the `file_chunk_request` event. Pass NULL to unset.
         *
         * This event is triggered when Core is ready to send more file data.
         */
        [CCode (cname = "tox_callback_file_chunk_request")]
        public void file_chunk_request_callback (FileChunkRequestFunc callback);

        /*******************************************************************************
         *
         * :: File transmission: receiving
         *
         ******************************************************************************/

        /**
         * The client should acquire resources to be associated with the file transfer.
         * Incoming file transfers start in the PAUSED state. After this callback
         * returns, a transfer can be rejected by sending a TOX_FILE_CONTROL_CANCEL
         * control command before any other control commands. It can be accepted by
         * sending TOX_FILE_CONTROL_RESUME.
         *
         * @param friend_number The friend number of the friend who is sending the file
         *   transfer request.
         * @param file_number The friend-specific file number the data received is
         *   associated with.
         * @param kind The meaning of the file to be sent.
         * @param file_size Size in bytes of the file the client wants to send,
         *   UINT64_MAX if unknown or streaming.
         * @param filename Name of the file. Does not need to be the actual name. This
         *   name will be sent along with the file send request.
         * @param filename_length Size in bytes of the filename.
         */
        [CCode (cname = "tox_file_recv_cb")]
        public delegate void FileRecvFunc (
            uint32 friend_number,
            uint32 file_number,
            FileKind kind,
            uint64 file_size,
            uint8[] filename
        );

        /**
         * Set the callback for the `file_recv` event. Pass NULL to unset.
         *
         * This event is triggered when a file transfer request is received.
         */
        [CCode (cname = "tox_callback_file_recv")]
        public void file_recv_callback (FileRecvFunc callback);

        /**
         * When length is 0, the transfer is finished and the client should release the
         * resources it acquired for the transfer. After a call with length = 0, the
         * file number can be reused for new file transfers.
         *
         * If position is equal to file_size (received in the file_receive callback)
         * when the transfer finishes, the file was received completely. Otherwise, if
         * file_size was UINT64_MAX, streaming ended successfully when length is 0.
         *
         * @param friend_number The friend number of the friend who is sending the file.
         * @param file_number The friend-specific file number the data received is
         *   associated with.
         * @param position The file position of the first byte in data.
         * @param data A byte array containing the received chunk.
         * @param length The length of the received chunk.
         */
        [CCode (cname = "tox_file_recv_chunk_cb")]
        public delegate void FileRecvChunkFunc (
            uint32 friend_number,
            uint32 file_number,
            uint64 position,
            uint8[] data
        );

        /**
         * Set the callback for the `file_recv_chunk` event. Pass NULL to unset.
         *
         * This event is first triggered when a file transfer request is received, and
         * subsequently when a chunk of file data for an accepted request was received.
         */
        [CCode (cname = "tox_callback_file_recv_chunk")]
        public void file_recv_chunk_callback (FileRecvChunkFunc callback);

        /*******************************************************************************
         *
         * :: Group chat management
         *
         ******************************************************************************/

        // Nothing yet.

        /*******************************************************************************
         *
         * :: Group chat message sending and receiving
         *
         ******************************************************************************/

        // Nothing yet.

        /*******************************************************************************
         *
         * :: Low-level custom packet sending and receiving
         *
         ******************************************************************************/

        /**
         * Send a custom lossy packet to a friend.
         *
         * The first byte of data must be in the range 200-254. Maximum length of a
         * custom packet is TOX_MAX_CUSTOM_PACKET_SIZE.
         *
         * Lossy packets behave like UDP packets, meaning they might never reach the
         * other side or might arrive more than once (if someone is messing with the
         * connection) or might arrive in the wrong order.
         *
         * Unless latency is an issue, it is recommended that you use lossless custom
         * packets instead.
         *
         * @param friend_number The friend number of the friend this lossy packet
         *   should be sent to.
         * @param data A byte array containing the packet data.
         * @param length The length of the packet data byte array.
         *
         * @return true on success.
         */
        /*
        private bool friend_send_lossy_packet (
            uint32 friend_number,
            uint8[] data,
            out TOX_ERR_FRIEND_CUSTOM_PACKET error
        );
        */
    }
}
