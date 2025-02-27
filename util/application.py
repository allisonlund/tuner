import tkinter as tk
import serial
import threading
import time

# Configure your serial port (adjust as needed)
SERIAL_PORT = "/dev/cu.usbserial-ib0RDpMt1"  # Change this to your USB port (e.g., "/dev/ttyUSB0" on Linux)
BAUD_RATE = 9600

# Try to open the serial port
try:
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
except serial.SerialException:
    ser = None
    print("Error: Could not open serial port.")

def read_serial():
    while True:
        if ser and ser.is_open:
            try:
                char = ser.read(1).decode('utf-8', errors='ignore')  # Read one character
                if char:
                    update_label(char)
            except Exception as e:
                print(f"Serial Read Error: {e}")
        time.sleep(2)  # Update every few seconds

def update_label(char):
    label.config(text=char)

# Create GUI window
root = tk.Tk()
root.title("Tuner")
root.geometry("300x300")

label = tk.Label(root, text="", font=("Arial", 48))
label.pack(expand=True)

# Start serial reading thread
threading.Thread(target=read_serial, daemon=True).start()

root.mainloop()

