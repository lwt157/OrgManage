// 引入必需的库：系统、绘图、图片格式、文件流、Web相关
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web;

namespace OrgManage.Account
{
    // 验证码页面类，专门用来生成图片验证码
    public partial class Captcha : System.Web.UI.Page
    {
        // 页面加载时自动执行（访问这个页面就生成验证码）
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. 生成 4位随机数字（1000~9999）
            string code = new Random().Next(1000, 9999).ToString();

            // 2. 把验证码存到 Session，登录/注册时用来校验
            Session["CaptchaCode"] = code;

            // 3. 创建一张 100×35 像素的空白图片
            using (Bitmap bmp = new Bitmap(100, 35))
            // 4. 获取图片的绘图对象，开始画图
            using (Graphics g = Graphics.FromImage(bmp))
            // 5. 创建内存流，用来保存最终图片
            using (MemoryStream ms = new MemoryStream())
            {
                // 6. 把图片背景填充为白色
                g.Clear(Color.White);
                Random rnd = new Random();

                // 7. 绘制 5 条随机干扰线（防机器识别）
                using (Pen pen = new Pen(Color.LightGray, 1))
                {
                    for (int i = 0; i < 5; i++)
                    {
                        g.DrawLine(pen, rnd.Next(100), rnd.Next(35), rnd.Next(100), rnd.Next(35));
                    }
                }

                // 8. 在图片上绘制刚才生成的 4位验证码（蓝色粗体）
                using (Font font = new Font("Arial", 16, FontStyle.Bold))
                {
                    g.DrawString(code, font, Brushes.SteelBlue, 10, 5);
                }

                // 9. 把画好的图片保存为 PNG 格式到内存流
                bmp.Save(ms, ImageFormat.Png);
                ms.Position = 0;

                // 10. 把内存流里的图片输出到浏览器，显示为图片
                Response.Clear();
                Response.ContentType = "image/png";
                Response.BinaryWrite(ms.ToArray());
                Response.Flush();
            }
        }
    }
}