import java.net.ServerSocket;

public class ConfigReceiver {

	public static void main(String[] args) throws Exception {
        System.out.println("The scaling service is running.");

        ServerSocket listener = new ServerSocket(9797);
        try {
            while (true) {
                new Thread(new ModelBasedScaler(listener.accept())).start();
            }
        } finally {
            listener.close();
        }
    }
}
