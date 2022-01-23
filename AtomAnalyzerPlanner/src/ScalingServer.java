
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


public class ScalingServer {

	HashMap<String, List<Integer>> state;

	public ScalingServer() {
		// TODO Auto-generated constructor stub
		state = new HashMap<>();
	}

	public void coordinator(List<Socket> sockets) {

		int clientNumber = 1;


		for (Socket socket : sockets) {
			
			DataAggregator agg=new DataAggregator(socket, clientNumber++);
			agg.process();
		}

	}

	public static void main(String[] args) {
		
		System.out.println("The scaling service is running.");
		int expectedClientNumber = 6;
		ScalingServer s = new ScalingServer();

		List<Socket> sockets = new ArrayList<>();

		ServerSocket listener = null;
		try {
			listener = new ServerSocket(9898);
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		try {
			while (true) {

				Socket socket = null;
				try {
					socket = listener.accept();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				sockets.add(socket);

				if (sockets.size() == expectedClientNumber) {
					s.coordinator(sockets);

					Snapshot tmp = Snapshot.getSnapshot();
					s.state = new HashMap<>();
					s.state.putAll(tmp.data);
					tmp.reset();
					s.state.forEach((k, v) -> System.out.println("Key: " + k + " Elements: " + v.size()));

					sockets = new ArrayList<>();
					
					SolutionProvider sp=new SolutionProvider(s.state);
					sp.solve();
					
				}

			}

		} finally {
			try {
				listener.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}