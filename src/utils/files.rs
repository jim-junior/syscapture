use std::fs;
use std::io;

pub fn readfile(file_path: &str) -> Result<String, io::Error> {
    let contents = fs::read_to_string(file_path);

    match contents {
        Ok(data) => {
            return Ok(data);
        }
        Err(error) => {
            return Err(error);
        }
    }
}
