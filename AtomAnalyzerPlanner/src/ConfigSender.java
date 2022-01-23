import java.io.IOException;
import java.io.ObjectOutputStream;
import java.net.Socket;

public class ConfigSender implements Runnable {

	double[] values;

	public ConfigSender(double[] values) {
		// TODO Auto-generated constructor stub
		this.values = values;
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub

		if (values[0] != 0) {
			Socket socket1 = null;
			Socket socket2 = null;

			try {
				// set your servername and port
				socket1 = new Socket("servername1", 9999);

				ObjectOutputStream outputStream1 = new ObjectOutputStream(socket1.getOutputStream());

				double[] server1 = new double[4];
				double[] server2 = new double[5];

				server1[0] = values[0];
				server1[1] = values[1];
				server1[2] = values[5];
				server1[3] = values[6];

				server2[0] = values[2];
				server2[1] = values[3];
				server2[2] = values[4];
				server2[3] = values[7];
				server2[4] = values[8];

				outputStream1.writeObject(server1);

				socket1.close();

				socket2 = new Socket("servername2", 9999);
				ObjectOutputStream outputStream2 = new ObjectOutputStream(socket2.getOutputStream());
				outputStream2.writeObject(server2);
				socket2.close();

			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	}
}
