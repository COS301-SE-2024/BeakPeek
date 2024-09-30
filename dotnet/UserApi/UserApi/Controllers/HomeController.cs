using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using UserApi.Models;
using Wangkanai.Detection.Models;
using Wangkanai.Detection.Services;

namespace UserApi.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;
    private readonly IDetectionService _detectionService;

    public HomeController(ILogger<HomeController> logger, IDetectionService detectionService)
    {
        _logger = logger;
        _detectionService = detectionService;
    }

    public IActionResult Index()
    {
        return View();
    }

    public IActionResult Privacy()
    {
        return View();
    }

    public IActionResult Mobile()
    {

        Console.WriteLine(_detectionService.Device.Type);

        var isAuthenticated = User.Identity?.IsAuthenticated ?? false;

        Console.WriteLine($"Is User Authenticated: {isAuthenticated}");
        if (_detectionService.Device.Type == Device.Mobile)
        {

            Console.WriteLine($"User is on mobile");
            if (isAuthenticated)
            {
                string? token = HttpContext.Session.GetString("Token");
                Console.WriteLine("Mobile user Authenticated");
                if (token is null)
                {
                    return View();
                }
                Console.WriteLine($"Mobile user Authenticated with token: {token}");

                var androidAppRedirectUrl = $"beakpeek://?token={token}";

                return Redirect(androidAppRedirectUrl);
            }
        }
        return View("Home");
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
