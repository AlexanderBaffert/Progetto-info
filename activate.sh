#!/bin/bash

# Check if venv exists, create it if it doesn't
if [ ! -d "venv" ]; then
    echo "Virtual environment not found. Running setup first..."
    bash setup.sh
    if [ $? -ne 0 ]; then
        echo "Setup failed. Please check the error messages above."
        exit 1
    fi
else
    # Activate the virtual environment
    echo "Activating virtual environment..."
    source venv/bin/activate
    
    # Check if Flask is installed
    if ! python -c "import flask" &> /dev/null; then
        echo "Flask not found in the virtual environment. Installing dependencies..."
        pip install -r requirements.txt
    else
        echo "Virtual environment activated successfully!"
    fi
fi

# Print helpful commands
echo ""
echo "You can now run the application with:"
echo "python server.py"
echo ""
echo "To deactivate the virtual environment when done, type:"
echo "deactivate"
