import os
from PIL import Image

def pad_image(input_path, output_path):
    print(f"Opening {input_path}")
    img = Image.open(input_path)
    img = img.convert("RGBA")
    
    # Calculate dimensions for a square image with padding
    # Android 12 splash screen icon is scaled down and cropped to a circle
    # The safe zone is about 2/3 of the width/height
    max_dim = max(img.width, img.height)
    new_size = int(max_dim * 1.5)  # Add enough padding so it fits in the circle
    
    # Create new transparent image
    new_img = Image.new("RGBA", (new_size, new_size), (0, 0, 0, 0))
    
    # Paste the original image in the center
    offset_x = (new_size - img.width) // 2
    offset_y = (new_size - img.height) // 2
    new_img.paste(img, (offset_x - 2, offset_y), img)
    
    print(f"Saving padded image to {output_path}")
    new_img.save(output_path)
    print("Done!")

if __name__ == "__main__":
    base_dir = r"c:\Users\rudra\AndroidStudioProjects\fest_app\assets\images"
    input_file = os.path.join(base_dir, "splash.png")
    output_file = os.path.join(base_dir, "splash_padded.png")
    
    if os.path.exists(input_file):
        pad_image(input_file, output_file)
    else:
        print(f"Error: {input_file} not found")
