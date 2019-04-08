# demosaicing

Identify bayer pattern for the given mosaiced images.

Bilinear interpolation for each plane was carried out separately. At each plane, blank pixels
were calculated by averaging the surrounding pixels of the same plane.
