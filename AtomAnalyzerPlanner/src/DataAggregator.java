import java.io.IOException;
import java.io.ObjectInputStream;
import java.net.Socket;
import java.util.HashMap;
import java.util.List;

public class DataAggregator {

	private Socket socket;
	private int clientNumber;

	public DataAggregator(Socket socket, int clientNumber) {
		this.socket = socket;
		this.clientNumber = clientNumber;

	}

	@SuppressWarnings("unchecked")
	public void process() {
		try {

			ObjectInputStream inStream = new ObjectInputStream(socket.getInputStream());

			HashMap<String, List<Integer>> partialSnapshot = (HashMap<String, List<Integer>>) inStream.readObject();
			System.out.println("Object received in: " + clientNumber);

			Snapshot tmp = Snapshot.getSnapshot();

			tmp.data.putAll(partialSnapshot);

			socket.close();

		} catch (IOException | ClassNotFoundException e) {
			System.out.println("Error handling client# " + clientNumber + ": " + e);
		}
	}

}
