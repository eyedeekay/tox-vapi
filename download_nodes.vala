void main() {
	var loop = new MainLoop ();
	var sess = new Soup.Session ();
	var msg = new Soup.Message ("GET", "https://build.tox.chat/job/nodefile_build_linux_x86_64_release/lastSuccessfulBuild/artifact/Nodefile.json");
	sess.send_async.begin (msg, null, (obj, res) => {
		var stream = sess.send_async.end (res);
		var json = new Json.Parser ();
		json.load_from_stream_async (stream, null, (obj, res) => {
			json.load_from_stream_async.end (res);
			var array = json.get_root ().get_object ().get_array_member ("servers");
			array.foreach_element ((arr, index, node) => {
				var entry = node.get_object ();
				var owner = entry.get_string_member ("owner");
				var region = entry.get_string_member ("region");
				var ipv4 = entry.get_string_member ("ipv4");
				var port = entry.get_int_member ("port");
				var ipv6 = entry.get_string_member ("ipv6");
				var pubkey = entry.get_string_member ("pubkey");
				print ("by %s in %s:\n%s:%lld | %s:%lld\n%s\n\n",
					owner, region,
					ipv4, port, ipv6, port,
					pubkey);
			});
			loop.quit ();
		});
	});
	loop.run ();
}
