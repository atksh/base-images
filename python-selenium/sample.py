from pyvirtualdisplay import Display
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

op = Options()
op.add_argument("--disable-gpu")
op.add_argument("--disable-extensions")
op.add_argument("--no-sandbox")
op.add_argument("--disable-dev-shm-usage")

if __name__ == "__main__":
    with Display(size=(2160, 3840)) as disp:
        driver = webdriver.Chrome(options=op)
        driver.set_window_size(2160, 3840)

        driver.get("https://reserve.tokyodisneyresort.jp/ticket/search/")
        driver.implicitly_wait(15)
        driver.save_screenshot("ss.png")

