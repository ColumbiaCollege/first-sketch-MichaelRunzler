import java.awt.Point;

// MB VARIABLES
color BG_COLOR = color(64, 64, 64);
color MB_COLOR = color(72, 160, 72);
color PROC_COLOR = color(128);
color PIN_COLOR = color(72);
color RAM_COLOR_A = color(72);
color RAM_COLOR_B = color(0, 0, 192);
color PCIe_COLOR = color(64);
color PCI_COLOR = color(238, 236, 230);

float MB_DIMENSIONS = 40.0f;
float PROC_DIMENSIONS = 8.0f;
float PIN_DIMENSIONS = 6.6f;
float INTER_RAM_GAP = 0.5f;
float INTER_PROC_GAP = 8.0f;
float INTER_PCI_GAP = 1.0f;
float INTER_PCI_BRIDGE_GAP = 10.0f;
float PCI_VRM_OFFSET = 4.0f;
float VRM_HS_DIMENSIONS = 2.0f;
float NB_GAP = 2.0f;
float NB_DIMENSIONS = 6.0f;
Point RAM_DIMENSIONS = new Point(1, 16);
Point PCIe_DIMENSIONS = new Point(15, 2);
Point PCI_DIMENSIONS = new Point(13, 2);

// HDD VARIABLES
color HOUSING_COLOR = color(160);
color LABEL_COLOR = color(255);
color TEXT_COLOR = color(72, 72, 255);
color TEXT_COLOR_2 = color(32);
color SPINDLE_COLOR = color(172);

float HDD_DIMENSIONS = 20.0f;
float SPINDLE_GAP = 1.0f;
float SPINDLE_RADIUS = HDD_DIMENSIONS - SPINDLE_GAP * 2;
float ACTUATOR_GAP = 1.0f;
float LABEL_GAP = 4.5f;
Point ACTUATOR_DIMENSIONS = new Point((int)(HDD_DIMENSIONS - ACTUATOR_GAP * 2), (int)(HDD_DIMENSIONS / 1.5f));
Point LABEL_DIMENSIONS = new Point(12, 16);
float LABEL_TEXT_OFFSET = 0.5f;
String LABEL_TEXT = "IBM";
String LABEL_TEXT_2 = "\n\n160GB IDE\nCYL 480\nHEAD 12\nSEC 330,640\n(c) 2002 IBM Corp.\nAll rights reserved.";

color RAM_CHIP_COLOR = color(48);
color RAM_FINGER_COLOR = color(230, 220, 86);
Point RAM_MODULE_DIMENSIONS = new Point(38, 9);
float RAM_FINGER_WIDTH = 1.0f;
float RAM_CHIP_SIZE = 2.0f;

void setup()
{
  size(720, 720);
  background(BG_COLOR);
}

void draw()
{
  // Stop the draw loop from running continuously, since we don't need multi-layering.
  noLoop();
  // Ensure shape modes
  rectMode(CORNER);
  ellipseMode(CENTER);
  
  motherboard();
  hdd();
  ram();
}

void ram()
{
  // Enable black outlines if they haven't been already
  stroke(0);
  
  // Draw base PCB
  fill(MB_COLOR);
  Point ram_module_size = new Point(percentage(true, RAM_MODULE_DIMENSIONS.x), percentage(false, RAM_MODULE_DIMENSIONS.y));
  Point ram_module_coords = getOffsetCoords(-1, percentage(true, 5.0f) + ram_module_size.x, -1, percentage(false, 25.0f) + ram_module_size.y);
  rect(ram_module_coords.x, ram_module_coords.y, ram_module_size.x, ram_module_size.y);
  
  // Draw connector fingers (gold contact strips)
  fill(RAM_FINGER_COLOR);
  int finger_width = percentage(false, RAM_FINGER_WIDTH);
  int finger_break = (int)(ram_module_size.x / 2) - finger_width;
  rect(ram_module_coords.x, ram_module_coords.y + ram_module_size.y, finger_break, finger_width);
  rect(ram_module_coords.x + ram_module_size.x / 2, ram_module_coords.y + ram_module_size.y, finger_break + finger_width, finger_width);
  
  // Draw left memory chip group
  int ram_chip_size = percentage(true, RAM_CHIP_SIZE);
  int ram_chip_x = ram_module_coords.x + ram_chip_size;
  for(int i = 1; i <= 4; i++){
    fill(RAM_CHIP_COLOR);
    rect(ram_chip_x, (int)((ram_module_coords.y + ram_module_size.y / 2) - ram_chip_size / 2), ram_chip_size, ram_chip_size);
    ram_chip_x += ram_chip_size * 2;
  }
  
  // Draw right memory chip group
  ram_chip_x = (ram_module_coords.x + ram_module_size.x) - ram_chip_size * 2;
  for(int i = 1; i <= 4; i++){
    fill(RAM_CHIP_COLOR);
    rect(ram_chip_x, (int)((ram_module_coords.y + ram_module_size.y / 2) - ram_chip_size / 2), ram_chip_size, ram_chip_size);
    ram_chip_x -= ram_chip_size * 2;
  }
}

void hdd()
{
  // Enable black outlines if they haven't been already
  stroke(0);
  
  // Draw housing
  fill(HOUSING_COLOR);
  Point housing_size = new Point(percentage(true, HDD_DIMENSIONS), percentage(true, HDD_DIMENSIONS * 1.46));
  Point housing_coords = getOffsetCoords(-1, percentage(true, 5.0f) + housing_size.x, percentage(false, 5.0f), -1);
  rect(housing_coords.x, housing_coords.y, housing_size.x, housing_size.y, 4);
  
  // Draw spindle
  fill(SPINDLE_COLOR);
  int spindle_radius = percentage(true, SPINDLE_RADIUS);
  Point spindle_coords = new Point(housing_coords.x + (int)(housing_size.x / 2), housing_coords.y + percentage(false, SPINDLE_GAP) + (spindle_radius / 2));
  ellipse(spindle_coords.x, spindle_coords.y, spindle_radius, spindle_radius);
  
  // Draw actuator housing
  fill(SPINDLE_COLOR);
  int actuator_gap = percentage(true, ACTUATOR_GAP);
  Point actuator_size = new Point(percentage(true, ACTUATOR_DIMENSIONS.x), percentage(false, ACTUATOR_DIMENSIONS.y));
  Point actuator_coords = new Point(housing_coords.x + actuator_gap, (housing_coords.y + housing_size.y) - (actuator_size.y + actuator_gap));
  rect(actuator_coords.x, actuator_coords.y, actuator_size.x, actuator_size.y, 10);
  
  // Disable outlines
  noStroke();
  
  // Draw another, slightly smaller, ellipse over the spindle housing to erase the outline on the merge point
  fill(SPINDLE_COLOR);
  int spindle_fill_radius = percentage(true, SPINDLE_RADIUS - 0.1);
  ellipse(spindle_coords.x, spindle_coords.y, spindle_fill_radius, spindle_fill_radius);
  
  // Re-enable outlines
  stroke(0);
  
  // Draw label
  // Set to centered rendering for the next rectangle to avoid messy coordinate calculations
  rectMode(CENTER);
  fill(LABEL_COLOR);
  Point label_size = new Point(percentage(true, LABEL_DIMENSIONS.x), percentage(false, LABEL_DIMENSIONS.y));
  Point label_coords = new Point(housing_coords.x + (int)(housing_size.x / 2), housing_coords.y + percentage(false, LABEL_GAP) + (label_size.y / 2));
  rect(label_coords.x, label_coords.y, label_size.x, label_size.y, 2);
  
  // Reset back to default mode
  rectMode(CORNER);
  
  // Draw label text
  fill(TEXT_COLOR);
  int label_offset = percentage(true, LABEL_TEXT_OFFSET);
  textSize(12);
  text(LABEL_TEXT, (label_coords.x - (int)(label_size.x / 2)) + label_offset, (label_coords.y - (int)(label_size.y / 2)) + label_offset, label_size.x - label_offset, label_size.y - label_offset);
  textSize(8);
  fill(TEXT_COLOR_2);
  text(LABEL_TEXT_2, (label_coords.x - (int)(label_size.x / 2)) + label_offset, (label_coords.y - (int)(label_size.y / 2)) + label_offset, label_size.x - label_offset, label_size.y - label_offset);
}

void motherboard()
{
  // Enable black outlines if they haven't been already
  stroke(0);
  
  // Draw motherboard base
  Point mb_coords = getOffsetCoords(percentage(true, 5.0f), -1, percentage(false, 5.0f), -1);
  Point mb_size = new Point(percentage(true, MB_DIMENSIONS), (int)(percentage(true, MB_DIMENSIONS) * 1.25));
  fill(MB_COLOR);
  rect(mb_coords.x, mb_coords.y, mb_size.x, mb_size.y);
  
  // Draw processor socket
  fill(PROC_COLOR);
  int proc_x = (int)(mb_coords.x + mb_size.x * 0.22);
  int proc_y = (int)(mb_coords.y + mb_size.x * 0.15);
  int proc_size = percentage(true, PROC_DIMENSIONS); 
  rect(proc_x, proc_y, proc_size, proc_size);
  
  // Draw processor pin array
  fill(PIN_COLOR);
  rect(proc_x + (proc_size * 0.10), proc_y + (proc_size * 0.10), percentage(true, PIN_DIMENSIONS), percentage(true, PIN_DIMENSIONS));
  
  // Draw RAM slots
  int ram_width = percentage(true, RAM_DIMENSIONS.x);
  int ram_gap = percentage(true, INTER_RAM_GAP);
  int ram_x = proc_x + percentage(true, INTER_PROC_GAP) + proc_size;
  
  for(int i = 1; i <= 4; i++){
    fill(i % 2 != 0 ? RAM_COLOR_A : RAM_COLOR_B);
    rect(ram_x, proc_y, ram_width, percentage(false, RAM_DIMENSIONS.y));
    
    ram_x += ram_width + ram_gap;
  }
  
  // Draw VRM heatsinks
  int vrm_sink_size = percentage(true, VRM_HS_DIMENSIONS);
  Point vrm_coords = getOffsetCoords(percentage(true, 8.5f), -1, percentage(false, 7.0f), -1);
  int vrm_y = vrm_coords.y;
  // vrm_gap would be the same as vrm_sink_size, just using that...
  for(int i = 1; i <= 5; i++){
    fill(PROC_COLOR);
    rect(vrm_coords.x, vrm_y, vrm_sink_size, vrm_sink_size);
    vrm_y += vrm_sink_size * 2;
  }
  
  // Draw northbridge
  int nb_size = percentage(true, NB_DIMENSIONS);
  fill(PROC_COLOR);
  rect(proc_x + (int)(proc_size / 2), proc_y + proc_size + percentage(false, NB_GAP), nb_size, nb_size);
  
  // Draw PCI and PCIe slots
  int pci_height = percentage(false, PCI_DIMENSIONS.y);
  int pcie_height = percentage(false, PCIe_DIMENSIONS.y);
  int pci_gap = percentage(false, INTER_PCI_GAP);
  int pci_vrm_offset = percentage(true, PCI_VRM_OFFSET);
  int pci_y = proc_y + percentage(false, INTER_PCI_BRIDGE_GAP) + proc_size;
  
  for(int i = 1; i <= 7; i++){
    if(i == 1 || i == 3){
      fill(PCIe_COLOR);
      rect(proc_x - pci_vrm_offset, pci_y, percentage(true, PCIe_DIMENSIONS.x), pcie_height);
      pci_y += pcie_height + pci_gap;
      continue;
    }
    
    fill(PCI_COLOR);
    rect(proc_x - pci_vrm_offset, pci_y, percentage(true, PCI_DIMENSIONS.x), pci_height);
    pci_y += pci_height + pci_gap;
  }
}

int percentage(boolean widthOrHeight, float percentage){
  return (int)(widthOrHeight ? (width * (percentage / 100)) : (height * (percentage / 100)));
}

Point getCenteredCoords(boolean horizontal, boolean vertical)
{
  Point res = new Point(0,0);
  
  if(horizontal) res.x = (width / 2);
  if(vertical) res.y = (height / 2);
  
  return res;
}

Point getOffsetCoords(int left, int right, int top, int bottom)
{
  Point res = new Point(0,0);
  res.x = (left >= 0) ? left : (width - right);
  res.y = (top >= 0) ? top : (height - bottom);
  
  return res;
}
