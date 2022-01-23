import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class Reporter implements Runnable {

	public String requestName;
	List<Integer> values;
	String server;

	public Reporter(String server) {
		// TODO Auto-generated constructor stub

		values = new ArrayList<>();
		this.server=server;
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub

		Socket socket = null;

		try {
			socket = new Socket(server, 9898);

			HashMap<String, List<Integer>> partialSnapshot = new HashMap<>();
			partialSnapshot.put(requestName, values);

			ObjectOutputStream outputStream = new ObjectOutputStream(socket.getOutputStream());

			outputStream.writeObject(partialSnapshot);

			values = new ArrayList<>();

			socket.close();

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
