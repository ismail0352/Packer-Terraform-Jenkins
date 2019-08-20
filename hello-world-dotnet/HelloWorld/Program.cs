using System;
using Newtonsoft.Json;

namespace HelloWorld
{
    public class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            var healthCheck = new HealthCheck { Status = "Success" };
            var jsonStr = JsonConvert.SerializeObject(healthCheck);
            Console.WriteLine(jsonStr);
            Console.ReadLine();
        }
    }
}
