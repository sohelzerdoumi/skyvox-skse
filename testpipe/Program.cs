using System;
using System.Text;
using System.IO;
using System.IO.Pipes;

namespace testpipe
{
    class Program
    {
        static void Main(string[] args)
        {
            while (true)
            {
                send("blablablablabla");
                System.Threading.Thread.Sleep(2000);
         
            }

        }

        public static void send(string data)
        {
            NamedPipeClientStream pipe = new NamedPipeClientStream(".", "SkyVox", PipeDirection.InOut, PipeOptions.Asynchronous);
            pipe.Connect();

            try
            {
                StreamWriter m_pipeServerWriter = new StreamWriter(pipe);
                m_pipeServerWriter.WriteLine(data);
                m_pipeServerWriter.Flush();

            }
            catch (Exception ex) { }


            pipe.Close();
        }

        static byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }
    }
}
