package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.citadao;
import dao.clientedao;
import dao.mascotadao;
import dao.productodao;
import dao.ventasdao;
import java.time.LocalDate;
import java.util.List;
import modelo.citas;
/**
 *
 * @author USUARIO
 */
@WebServlet(name = "controladorseccion", urlPatterns = {"/controladorseccion"})
public class controladorseccion extends HttpServlet {

    private final String paginicio = "/vista/paneladmin.jsp";
    private final String pagcitas = "/vista/gcitas.jsp";
    private final String paginventario = "/vista/ginventario.jsp";
    private final String pagventas = "/vista/gventas.jsp";
    private final String pagclientes = "/vista/gclientes.jsp";
    private final String pagmascotas = "/vista/gmascotas.jsp";
    private final String pagusuarios = "/vista/gusuarios.jsp";
    private final String pagperfil = "/vista/gperfil.jsp";
    

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String seccion = request.getParameter("seccion");
        if (seccion == null) {
            seccion = "inicio";
        }
        switch (seccion) {
            case "inicio":
                inicio(request, response);
                break;
            case "citas":
                citas(request, response);
                break;
            case "inventario":
                inventario(request, response);
                break;
            case "ventas":
                ventas(request, response);
                break;
            case "clientes":
                clientes(request, response);
                break;
            case "mascotas":
                mascotas(request, response);
                break;
            case "usuarios":
                usuarios(request, response);
                break;
            case "horarios":
                horarios(request,response);
                break;
            case "perfil":
                perfil(request,response);
                break;
            default:
                throw new AssertionError();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void inicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("paginaActual", "inicio");
        clientedao cldao = new clientedao();
        mascotadao mdao = new mascotadao();
        ventasdao vdao = new ventasdao();
        citadao cdao = new citadao();
        productodao pdao = new productodao();
        
        // TARJETAS PRINCIPALES
        request.setAttribute("totalClientes",cldao.contarClientesActivos());
        request.setAttribute("totalMascotas",mdao.contarMascotas());
        request.setAttribute("totalCitas",cdao.totalCitas());
        request.setAttribute("ingresos", vdao.ingresosMes());
        request.setAttribute("totalProductos",pdao.contarProductos());
        // GRÁFICOS
        request.setAttribute("ventasSemana",java.util.Arrays.toString(vdao.ventasSemana()));
        request.setAttribute("citasSemana",java.util.Arrays.toString(cdao.citasSemana()));
        request.setAttribute("ingresos12Meses",java.util.Arrays.toString(vdao.ingresosUltimos12Meses()));
        // TABLAS
        request.setAttribute("proximasCitas",cdao.listarProximasCitas());
        request.setAttribute("ultimasVentas",vdao.ultimasVentas());
        request.setAttribute("ultimosClientes",cldao.ultimosClientes());
        request.setAttribute("topProductos",pdao.topProductosVendidos());
        request.setAttribute("topClientes", cldao.topClientesCompradores());
        request.setAttribute("serviciosTop",cdao.serviciosMasSolicitados());
        request.setAttribute("productosCriticos", pdao.productosCriticos());
        request.setAttribute("productosPorVencer",pdao.productosPorVencer());
        // INDICADORES
        request.setAttribute("crecimiento",vdao.crecimientoMensual());
        request.setAttribute("ingresosMes", vdao.ingresosMes());
        request.setAttribute("clientesNuevos",cldao.contarClientesNuevos());
        request.setAttribute("mascotasRegistradas",mdao.contarMascotas());
        request.setAttribute("totalVentas",vdao.contarVentas());
        request.setAttribute("productosVendidos", vdao.productosVendidosMes());
        
        HttpSession session = request.getSession();
        Integer idUsuario
                = (Integer) session.getAttribute("id");
        citadao dao = new citadao();
        citas proxima
                = dao.obtenerProximaCitaCliente(idUsuario);
        request.setAttribute(
                "proximaCita",
                proxima
        );
        dao.mascotadao daoMascota
                = new dao.mascotadao();

        java.util.List<modelo.mascotas> listaMascotas
                = daoMascota.listarMascotasPorCliente(idUsuario);
        request.setAttribute(
                "misMascotas",
                listaMascotas
        );
        // CALENDARIO
        String fechaHoy
                = java.time.LocalDate.now().toString();
        request.setAttribute(
                "horasDisponibles",
                dao.obtenerHorasDisponibles(fechaHoy)
        );
        request.setAttribute(
                "horasOcupadas",
                dao.obtenerHorasOcupadas(fechaHoy)
        );
        // SEMANA
        LocalDate hoy = LocalDate.now();
        String semanaParam = request.getParameter("semana");
        LocalDate inicioSemana;
        if (semanaParam != null) {
            inicioSemana = LocalDate.parse(semanaParam);
        } else {
            inicioSemana = hoy.with(
                    java.time.DayOfWeek.MONDAY
            );
        }
        LocalDate finSemana
                = inicioSemana.plusDays(6);
        request.setAttribute(
                "inicioSemana",
                inicioSemana
        );
        request.setAttribute(
                "finSemana",
                finSemana
        );
        
        List<citas> agendaSemana
                = dao.obtenerCitasSemana(
                        inicioSemana.toString(),
                        finSemana.toString()
                );
        request.setAttribute(
                "agendaSemana",
                agendaSemana
        );
        request.getRequestDispatcher(paginicio).forward(request, response);
    }

    private void inventario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/controladorinventario?accion=listar").forward(request, response);
    }



    private void perfil(HttpServletRequest request, HttpServletResponse response)              
            throws ServletException, IOException {
        request.getRequestDispatcher("controladorperfil").forward(request, response);
    }

    private void citas(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/controladorcitas?accion=listar").forward(request, response);
    }

    private void ventas(HttpServletRequest request, HttpServletResponse response)  
            throws ServletException, IOException {
        request.setAttribute("paginaActual", "ventas");

        request.getRequestDispatcher(pagventas).forward(request, response);
    }

    private void clientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/controladorcliente?accion=listar").forward(request, response);
    }

    private void mascotas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/controladormascota?accion=listar").forward(request, response);
    }

    private void usuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/controladorusuarios?accion=listar").forward(request, response);
    }
    private void horarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/controladorhorario?accion=listar").forward(request, response);
    }

}
