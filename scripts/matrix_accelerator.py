import serial
import time
import numpy as np

# matrix_accelerator.py
# The script will control the matrix accelerator via serial port and compare matrix multiplication results between FPGA and Python

def open_serial_port(baud_rate):
    # Open the serial port
    serial_port = serial.Serial(
        port="COM3",                # Serial port name on Windows
        baudrate=baud_rate,         # Baud rate
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=1,                  # Read timeout in seconds
    )

    return serial_port

def close_serial_port(serial_port):
    # Close the serial port
    serial_port.close()

def send_matrix_data(serial_port, matrix_a, matrix_b):
    # Send the matrix data to the FPGA via UART

    a_bytes = np.asarray(matrix_a, dtype=np.int8).tobytes()
    b_bytes = np.asarray(matrix_b, dtype=np.int8).tobytes()
    matrix_data = a_bytes + b_bytes
    serial_port.write(matrix_data)

def receive_computed_matrix(serial_port):
    # Receive the computed matrix from the FPGA via UART
    # The computed output matrix is 192 bytes, 3 bytes per element
    print("Receiving computed matrix...")
    output_matrix = serial_port.read(192)

    if len(output_matrix) != 192:
        print("Error: Received matrix is not 192 bytes")
        return None

    return output_matrix

def compare_matrix_results(matrix_a, matrix_b, output_matrix):
    # Compute the matrix multiplication accumulation using numpy and compare with the output matrix from the FPGA
    print("Comparing matrix results...")

def main():
    # Main function to interact with the matrix accelerator
    # Each element in the matrix is a signed 8-bit integer

    # Open the serial port
    serial_port = open_serial_port(115200)
    print("Serial port opened")

    # Test Matrix A and B all 0's
    matrix_a = [[0] * 8 for _ in range(8)]
    matrix_b = [[0] * 8 for _ in range(8)]
    send_matrix_data(serial_port, matrix_a, matrix_b)

    close_serial_port(serial_port)
    print("Serial port closed")

if __name__ == "__main__":
    main()
